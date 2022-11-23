<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    use HasFactory;

    public function equipements(){
        return $this->belongsToMany(Equipement::class);
    }

    public function statistiquesBonus(){
        return $this->belongsToMany(Statistique::class, 'item_statistique_bonus')->withPivot('valeur');
    }
    public function statistiquesConditions(){
        return $this->belongsToMany(Statistique::class, 'item_statistique_condition')->withPivot('valeur');
    }
}
