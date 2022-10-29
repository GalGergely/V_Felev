<?php

namespace App\Http\Controllers;

use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ItemController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //HELP: nincs datum szerint sortolas prainatenel
        $items = Item::paginate(6);
        return view('site.items', ['items' => $items]);
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (Auth::user()->is_admin) {
            return view('site.item_form');
        } else {
            abort(404);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'description' => 'required|string',
            'obtained' => 'required|date',
            'file' => 'file'
        ]);
        //HELP: nem mukodik a beillesztes. az obtaineddel van valami gond, hiaba megy at a validaten
        $validated['file'] = 'asdasd';
        $item = Item::create($validated);
        return redirect()->route('items.show', ['item' => $item->id]);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $item = Item::findOrFail($id);
        return view('site.item', ['item' => $item]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
    /**
     * Display a listing of all tickets.
     * TODO: Csak admin férjen hozzá!
     */
    public function all()
    {
        $items = Item::paginate(6)->sortByDesc(function ($item) {
            return $item->obtained->sortByDesc('obtained')->first();
        });
        return view('site.items', ['items' => $items]);
    }

    public function newComment(Request $request, $id)
    {
        $validated = $request->validate([
            'text' => 'required|string',
            'file' => 'file',
        ]);

        $item = Item::findOrFail($id);

        $item->comments()->create([
            'text' => $validated['text'],
            'user_id' => Auth::id(),
        ]);

        return redirect()->route('items.show', ['item' => $item->id]);
    }
}
