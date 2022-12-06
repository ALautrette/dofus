<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Equipement extends Model
{
    use HasFactory;


    public $timestamps = false;

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function classe(){
        return $this->belongsTo(Classe::class);
    }

    public function items(){
        return $this->belongsToMany(Item::class, 'equipement_item');
    }
}
