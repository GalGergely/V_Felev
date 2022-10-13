@extends('layouts.layout')

@section('title','$ticket->title')

@section('content')
<div class="container-fluid px-5 my-3">
    <div class="d-flex">
        <h1 class="ps-3 me-auto">[Feladat tárgya] <span class="badge bg-danger">
            @switch($ticket->priority)
            @case(0)
                <span class="badge rounded-pill bg-info fs-6">Alacsony</span>
                @break
            @case(1)
                <span class="badge rounded-pill bg-success fs-6">Normál</span>
                @break
            @case(2)
                <span class="badge rounded-pill bg-warning fs-6">Magas</span>
                @break
            @case(3)
                <span class="badge rounded-pill bg-danger fs-6">Azonnal</span>
                @break
        @endswitch</span></h1>
        <button class="btn btn-primary mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Szerkesztés">
            <i class="fa-solid fa-pen-to-square fa-fw fa-xl"></i>
        </button>
        <button class="btn btn-primary mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Felhasználók">
            <i class="fa-solid fa-users fa-fw fa-xl"></i>
        </button>
        <button class="btn btn-success mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Lezárás">
            <i class="fa-solid fa-check fa-fw fa-xl"></i>
        </button>
        <button class="btn btn-danger mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Törlés">
            <i class="fa-solid fa-trash fa-fw fa-xl"></i>
        </button>
    </div>
    <hr />
    @foreach ($ticket->comment->sortByDesc('created_at') as $comment)
    <div class="card mb-3">
        <div class="card-header d-flex">
            <div class="me-auto"><span class="badge bg-secondary">#0</span> | <strong>{{$comment->user->name}}</strong> | {{$comment->created_at}}</div>
            @if ($comment->filename)
                <div><a href="#"><i class="fa-solid fa-download"></i></a></div>
            @endif
        </div>
        <div class="card-body">
            {{$comment->text}}
        </div>
    </div>
    @endforeach
    <hr>
    <h2>Új hozzászólás írása</h2>
    <form>
        <div class="mb-3">
            <textarea class="form-control" name="text" id="text" cols="30" rows="10" placeholder="Hozzászólás..."></textarea>
        </div>
        <div class="mb-3">
            <input type="file" class="form-control" id="file">
        </div>
        <div class="row">
            <button type="submit" class="btn btn-primary">Küldés</button>
        </div>
    </form>
</div>

@endsection
