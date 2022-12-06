<?php

namespace App\Models;

use App\Http\Controllers\ItemController;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Route;


class Item extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function equipements(){
        return $this->belongsToMany(Equipement::class, 'equipement_item');
    }

    public function statistiquesBonus(){
        return $this->belongsToMany(Statistique::class, 'item_statistique_bonus')->withPivot('valeur');
    }
    public function statistiquesConditions(){
        return $this->belongsToMany(Statistique::class, 'item_statistique_condition')->withPivot('valeur');
    }

    public function type(){
        return $this->belongsTo(Type::class);
    }

    public function getType(){
        return $this->type()->first();
    }
}
