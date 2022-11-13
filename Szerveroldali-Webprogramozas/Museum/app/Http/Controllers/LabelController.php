<?php

namespace App\Http\Controllers;

use App\Models\Label;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Session;

class LabelController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $labels = Label::all();
        return view('site.labels', ['labels' => $labels]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (Auth::user()->is_admin) {
            return view('site.label_form');
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
            'display' => 'required|boolean',
            'color' => 'required|string'
        ]);
        $label = Label::create($validated);
        Session::flash('label_created', $label->name);
        return redirect()->route('labels.index');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $label = Label::findOrFail($id);
        return view('site.label', ['label' => $label]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $label = Label::findOrFail($id);
        if (!Auth::user()->is_admin) {
            abort(401);
        }
        return view('site.label_form', ['label' => $label]);
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
        $validated = $request->validate([
            'name' => 'required|string',
            'display' => 'required|boolean',
            'color' => 'required|string'
        ]);
        $label = Label::findOrFail($id);
        if (!Auth::user()->is_admin) {
            abort(401);
        }
        $label->update($validated);
        Session::flash('label_updated', $label->name);
        return redirect()->route('labels.index');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $label = Label::findOrFail($id);
        if (!Auth::user()->is_admin) {
            abort(401);
        }
        $label->delete();
        $labels = Label::all();
        Session::flash('label_deleted', $label->name);
        return redirect()->route('labels.index');
    }

    public function all()
    {
        $labels = Label::all();
        return view('site.labels', ['labels' => $labels]);
    }
}
