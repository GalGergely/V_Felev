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
    
    Route::post('items/{item}/comment', [ItemController::class, 'newComment'])->name('items.newComment');
    Route::post('items/{item}/{comment}', [ItemController::class, 'deleteComment'])->name('items.deleteComment');
    Route::post('comment_form/{comment}', [ItemController::class, 'editComment'])->name('items.editComment');
    Route::post('comment/{comment}', [ItemController::class, 'updateComment'])->name('items.updateComment');



});
Route::get('labels', [LabelController::class, 'index'])->name('labels.index');
Route::resource('items', ItemController::class);
Route::resource('labels', LabelController::class);
Route::get('/', function () {
    return redirect()->route('items.index');
})->name('items');
require __DIR__ . '/auth.php';
