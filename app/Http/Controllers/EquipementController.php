<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class EquipementController extends Controller
{
    //
    public function makeEquipement()
    {
        return view('makeequipement');
    }
    public function equipementEnregistrer()
    {
        return view('equipement_enregistrer');
    }
    public function info()
    {
        return view('info');
    }

    public function create()
    {
        return view('infos');
    }

    public function store(Request $request)
    {
        return 'Le nom est ' . $request->input('nom');
    }
}
