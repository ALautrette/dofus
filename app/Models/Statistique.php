<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Statistique extends Model
{
    use HasFactory;

    public function itemsBonus(){
        return $this->belongsToMany(Item::class, 'item_statistique_bonus')->withPivot('valeur');
    }

    public function itemsConditions(){
        return $this->belongsToMany(Item::class, 'item_statistique_condition')->withPivot('valeur');
    }
}
