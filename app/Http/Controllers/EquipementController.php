<?php

namespace App\Http\Controllers;

use App\Models\Classe;
use App\Models\Emplacement;
use App\Models\Equipement;
use App\Models\Item;
use App\Models\Statistique;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class EquipementController extends Controller
{

    public function show($id)
    {
        $equipement = Equipement::findOrFail($id);
        $equipes = [];
        $items = Item::all();
        $objets = array();
        foreach ($items as $item) {
            if (isset($objets[$item->type->emplacement->libelle])) {
                $objets[$item->type->emplacement->libelle][] = $item;
            } else {
                $objets[$item->type->emplacement->libelle] = [$item];
            }
        }
        $statistiques = Statistique::all();
        $equipementStats = [];
        $countDofus = 1;
        foreach ($statistiques as $statistique) {

            $equipementStats[$statistique->libelle] = 0;

        }
        foreach ($equipement->items as $item) {
            $emplacement = $item->type->emplacement->libelle;

            if (!isset($equipes[$emplacement])) {
                $equipes[$emplacement] = $item;

            } else {
                if ($emplacement == 'Anneau') {
                    $equipes['Anneau1'] = $item;
                } elseif ($emplacement == 'Dofus') {
                    $equipes[$emplacement . $countDofus++] = $item;
                }
            }
            foreach ($item->statistiquesBonus as $statistique) {
                $equipementStats[$statistique->libelle] += $statistique->pivot->valeur;

            }
        }

        return view('equipement.show', [
            'equipement' => $equipement,
            'emplacements' => Emplacement::all(),
            'equipes' => $equipes,
            'items' => $objets,
            'equipeCaracs' => $equipementStats,
            'caracs' => $statistiques,
        ]);
    }

    public function save(Request $request, $id)
    {
        $data = $request->except("_token");
        DB::table('equipement_item')->where('equipement_id', $id)->delete();
        foreach ($data as $value) {
            try {
                DB::table('equipement_item')->insert([
                    'equipement_id' => $id,
                    'item_id' => $value,
                ]);
            } catch (QueryException $e) {
                return redirect()->back()->withErrors(['error' => $e->getMessage()]);
            }


        }
        return redirect()->route('show_equipement', [
            'id' => $id,

        ]);
    }

    public function makeEquipement()
    {
        $classes = Classe::all();
        return view('makeequipement', [
            "classes" => $classes
        ]);
    }

    public function equipementEnregistrer()
    {
        return view('equipement_enregistrer');
    }

    public function saveEquipement(Request $request)
    {

        $nom = $request->input("nomEquipement");
        $classe = $request->input("classe");
        $equipement = new Equipement;
        $equipement->classe_id = $classe;
        $equipement->nom = $nom;
        $equipement->user_id = Auth::id();
        $equipement->save();
        return redirect()->route("show_equipement", ["id" => $equipement->id]);
    }
}
