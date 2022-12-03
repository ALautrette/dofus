<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\EquipementController;
use App\Http\Controllers\UsersController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});


Route::get('/login', function () {
    return view('auth.login');
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

Route::get('/makeequipement',  [EquipementController::class, 'makeEquipement'])->name('makeequipement');

Route::get('/info',  [EquipementController::class, 'info'])->name('info');

Route::get('/equipement_enregistrer',  [EquipementController::class, 'equipementEnregistrer'])->name('equipement_enregistrer');

Route::get('users', [EquipementController::class, 'create']);
Route::post('users', [EquipementController::class, 'store']);
