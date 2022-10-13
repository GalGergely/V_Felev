<?php

use App\Http\Controllers\TicketController;
use Illuminate\Support\Facades\Route;
use App\Modells\Ticket;
use Illuminate\Support\Facades\Auth;

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

Route::resource('tickets', TicketController::class)->middleware('auth');


Route::get('/', function () {
})->middleware(['auth'])->name('tickets');

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

require __DIR__ . '/auth.php';
