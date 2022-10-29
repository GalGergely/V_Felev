<?php

use App\Http\Controllers\ItemController;
use App\Http\Controllers\LabelController;
use Illuminate\Support\Facades\Route;

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

Route::middleware('auth')->group(function () {
    Route::get('items/create', [ItemController::class, 'create'])->name('items.create');
    Route::get('labels/create', [LabelController::class, 'create'])->name('labels.create');

    Route::resource('items', ItemController::class);
    Route::resource('labels', LabelController::class);
    Route::post('items/{item}/comment', [ItemController::class, 'newComment'])->name('items.newComment');

    Route::get('/', function () {
        return redirect()->route('items.index');
    })->name('items');

    Route::get('/dashboard', function () {
        return view('dashboard');
    })->middleware(['verified'])->name('dashboard');
});

require __DIR__ . '/auth.php';
