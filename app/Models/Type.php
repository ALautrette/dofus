<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Type extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function emplacement(){
        return $this->belongsTo(Emplacement::class);
    }

    public function getEmplacement(){
        return $this->emplacement()->first();
    }
}
