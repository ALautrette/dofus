<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Classe extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function equipements(){
        return $this->belongsToMany(Equipement::class);
    }
}
