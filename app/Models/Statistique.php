<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Statistique extends Model
{
    use HasFactory;

    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'libelle',
        'image_path',
    ];

    public function itemsBonus(){
        return $this->belongsToMany(Item::class, 'item_statistique_bonus')->withPivot('valeur');
    }

    public function itemsConditions(){
        return $this->belongsToMany(Item::class, 'item_statistique_condition')->withPivot('valeur');
    }
}
