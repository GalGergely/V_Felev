@extends('layouts.layout')

@section('title','$item->name')

@section('content')
<div class="container-fluid px-5 my-3">
    <div class="d-flex">
        <h1 class="ps-3 me-auto">{{$item->name}}
        @if (Auth::user()->is_admin)
        <span class="badge bg-danger">
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
        @endif
    </div>
    <div class="d-flex">
        <h2>{{$item->description}}</h2>
    </div>
    <div class="d-flex">
        <img src="https://www.w3schools.com/images/w3schools_green.jpg" alt="W3Schools.com">
    </div>
    <hr />
    <div class="container-fluid px-5 my-3">
        <div class="d-flex">
            <h2>Labels:<br></h2>
        </div>
        <div class="d-flex">
            @foreach ($item->labels as $label)
                @if ($label->display=='1')
                    <span class="badge rounded-pill bg-info fs-6" data-tor="bg({{$label->color}})">{{$label->color}} {{$label->name}}</span>
                    <!--HELP: miert nem mukodik itt a data tor atalitas, https://toruskit.com/docs/components/badges/ -->
                    <span class="badge" data-tor="bg(#269389)">#269389</span>
                @endif
            @endforeach
        </div>
    </div>
    <hr />
    <div class="container-fluid px-5 my-3">
        <div class="d-flex">
            <h3>Comments:</h3>
        </div>
    </div>
    @if ($item->comments->isEmpty())
    <div class="card mb-3">
        No comments yet
    </div>
    @endif
    @foreach ($item->comments as $comment)
    <div class="card mb-3">

        <div class="card-header d-flex">
            <div class="me-auto"><span class="badge bg-secondary">{{$comment->user->name}}</span> | {{$comment->created_at}}</div>
        </div>
        <div class="card-body">
            {{$comment->text}}
        </div>
    </div>
    @endforeach
    <hr>
    <h2>Create a new comment</h2>
    <form action="{{ route('items.newComment', ['item'=> $item->id]) }}" method="post">
        @csrf
        <div class="mb-3">
            <textarea class="form-control" name="text" id="text" cols="30" rows="10" placeholder="Comment..."></textarea>
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
