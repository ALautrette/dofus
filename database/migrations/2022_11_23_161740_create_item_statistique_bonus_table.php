<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('item_statistique_bonus', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('item_id');
            $table->foreign('item_id')->references('id')->on('items')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            $table->unsignedBigInteger('statistique_id');
            $table->foreign('statistique_id')->references('id')->on('statistiques')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            $table->integer('valeur');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
};
