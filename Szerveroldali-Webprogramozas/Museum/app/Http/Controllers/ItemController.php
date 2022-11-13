<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Str;

class ItemController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $items = Item::orderBy('obtained', 'desc')->paginate(6);
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
            'labels' => 'nullable|array',
            'labels.*' => 'numeric|integer|exists:labels,id',
            'image' => 'nullable|file|image|mimes:jpg,png,bmp|max:4096'
        ]);

        $cover_image_path = null;
        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $cover_image_path = 'image' . Str::random(10) . '.' . $file->getClientOriginalExtension();
            Storage::disk('public')->put($cover_image_path, $file->get());
        }

        $validated['image'] = $cover_image_path;
        $item = Item::create($validated);

        if (isset($validated['labels'])) {
            $item->labels()->sync($validated['labels']);
        }
        Session::flash('item_created', $item->name);
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
        $item = Item::findOrFail($id);
        if (!Auth::user()->is_admin) {
            abort(401);
        }
        return view('site.item_form', ['item' => $item]);
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
            'description' => 'required|string',
            'obtained' => 'required|date',
            'labels' => 'nullable|array',
            'labels.*' => 'numeric|integer|exists:labels,id',
            'image' => 'nullable|file|image|max:4096'
        ]);



        $item = Item::findOrFail($id);
        if (!Auth::user()->is_admin) {
            abort(401);
        }

        $cover_image_path = $item->image;
        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $cover_image_path = 'image' . Str::random(10) . '.' . $file->getClientOriginalExtension();
            Storage::disk('public')->put($cover_image_path, $file->get());
        }

        $validated['image'] = $cover_image_path;

        $item->update($validated);
        if (isset($validated['labels'])) {
            $item->labels()->sync($validated['labels']);
        }

        Session::flash('item_updated', $item->name);

        return redirect()->route('items.show', ['item' => $item->id]);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $item = Item::findOrFail($id);
        if (!Auth::user()->is_admin) {
            abort(401);
        }
        $item->delete();
        $items = Item::paginate(6);
        Session::flash('item_deleted', $item->name);
        return redirect()->route('items', ['items' => $items]);
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

        Session::flash('comment_created', Auth::user()->name);

        return redirect()->route('items.show', ['item' => $item->id]);
    }

    public function deleteComment($itemid, $id)
    {
        $comment = Comment::findOrFail($id);
        $item = Item::findOrFail($itemid);
        if (!Auth::user()->is_admin && $comment->user->id != Auth::id()) {
            abort(401);
        }
        $us=$comment->user;
        $comment->delete();
        Session::flash('comment_deleted', $us->name);
        return redirect()->route('items.show', ['item' => $item->id]);
    }

    public function editComment($id)
    {
        $comment = Comment::findOrFail($id);
        if (!Auth::user()->is_admin && $comment->user->id != Auth::id()) {
            abort(401);
        }
        return view('site.comment_form', ['comment' => $comment]);
    }

    public function updateComment(Request $request, $id)
    {
        $validated = $request->validate([
            'text' => 'required|string',
            'file' => 'file',
        ]);
        $validated['file'] = 'asdasd';
        $comment = Comment::findOrFail($id);
        if (!Auth::user()->is_admin && $comment->user->id != Auth::id()) {
            abort(401);
        }
        $comment->update($validated);

        Session::flash('comment_updated', $comment->user->name);
        return redirect()->route('items.show', ['item' => $comment->item->id]);
    }
}
