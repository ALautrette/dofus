<?php

namespace App\Http\Controllers;

use App\Models\Classe;
use App\Models\Equipement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use const http\Client\Curl\AUTH_ANY;

class EquipementController extends Controller
{
    //
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
        $equipement->classe_id=$classe;
        $equipement->nom=$nom;
        $equipement->user_id=Auth::id();
        $equipement->save();
        return redirect()->route("show_equipement", ["id"=>$equipement->id]);
    }
}
