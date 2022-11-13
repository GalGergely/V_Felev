@extends('layouts.layout')

@section('title',$item->name)

@section('content')

<div class="container-fluid px-5 my-3">
        @if (Session::has('item_created'))
            <div class="alert alert-success" role="alert">
                New item "{{ Session::get('item_created') }}" has been successfuly created.
            </div>
        @endif
        @if (Session::has('item_updated'))
            <div class="alert alert-success" role="alert">
                New item "{{ Session::get('item_updated') }}" has been successfuly updated.
            </div>
        @endif
        @if (Session::has('comment_created'))
            <div class="alert alert-success" role="alert">
                "{{ Session::get('comment_created') }}"'s comment has been successfuly added.
            </div>
        @endif
        @if (Session::has('comment_updated'))
            <div class="alert alert-success" role="alert">
            "{{ Session::get('comment_updated') }}"'s comment has been successfuly updated.
            </div>
        @endif
        @if (Session::has('comment_deleted'))
            <div class="alert alert-success" role="alert">
            "{{ Session::get('comment_deleted') }}"'s comment has been successfuly deleted.
            </div>
        @endif
    <div class="d-flex">
        <h1 class="ps-3 me-auto">{{$item->name}}
        @auth
        @if (Auth::user()->is_admin)
        <span class="badge bg-danger">
        <a href="{{ route('items.edit', ['item' => $item->id]) }}" class="btn btn-primary mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Szerkesztés">
            <i class="fa-solid fa-pen-to-square fa-fw fa-xl"></i>
        </a>
        <form action="{{ route('items.destroy', ['item' => $item->id ]) }}" method="post">
            @csrf
            @method('delete')
            <button class="btn btn-danger mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Törlés" type="submit">
                <i class="fa-solid fa-trash fa-fw fa-xl"></i>
            </button>
        </form>
        @endif
        @endauth
    </div>
    <div class="d-flex">
        <h2>{{$item->description}}</h2>
    </div>
    <div class="d-flex">
        <img height=100 src="{{ asset($item->image ? 'storage/' . $item->image : 'images/favicon.png') }}">
    </div>
    <hr />
    <div class="container-fluid px-5 my-3">
        <div class="d-flex">
            <h2>Labels:<br></h2>
        </div>
        <div class="d-flex">
            @foreach ($item->labels as $label)
                @if ($label->display=='1')
                    <span class="badge rounded-pill fs-6" style="background-color: {{$label->color}}">{{$label->name}}</span>
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


            @auth
            @if (Auth::user()->is_admin or $comment->user->id == Auth::id())
        <form action="{{ route('items.editComment', ['comment' => $comment->id]) }}" method="post">
            @csrf
            <button class="btn btn-danger mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Törlés" type="submit">
                <i class="fa-solid fa-pen-to-square fa-fw fa-xl"></i>
            </button>
        </form>
        <form action="{{ route('items.deleteComment', ['item' => $item->id, 'comment' => $comment->id]) }}" method="post">
            @csrf
            <button class="btn btn-danger mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Törlés" type="submit">
                <i class="fa-solid fa-trash fa-fw fa-xl"></i>
            </button>
        </form>
        @endif
        @endauth




        </div>
        <div class="card-body">
            {{$comment->text}}
        </div>
    </div>
    @endforeach
    <hr>
    @auth
    <h2>Create a new comment</h2>
    <form action="{{ route('items.newComment', ['item'=> $item->id]) }}" method="post">
        @csrf
        <div class="mb-3">
            <textarea class="form-control" name="text" id="text" cols="30" rows="10" placeholder="Comment..."></textarea>
        </div>
        <div class="row">
            <button type="submit" class="btn btn-primary">Comment</button>
        </div>
    </form>
    @else
    <div class="mb-3">
            <h2>You have to sigh in to add comments</h2>
    </div>
    @endauth
</div>

@endsection
