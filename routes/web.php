<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\EquipementController;

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

Route::get('/test', function (){
    $array = array();
    $array['oui'] = ['non'];
    $array['oui'][] = ['mais'];
    dd($array);
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

Route::get('/makeEquipement', [App\Http\Controllers\HomeController::class, 'index'])->name('makeEquipement');

Route::get('/equipement/{id}', [EquipementController::class, 'show'])->name('show_equipement');

Route::post('/equipement/save/{id}', [EquipementController::class, 'save'])->name('save_equipement')->middleware('auth');

