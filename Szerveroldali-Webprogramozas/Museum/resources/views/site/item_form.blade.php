@extends('layouts.layout')

@section('title', 'New Item')

@section('content')
        <div class="container-fluid px-5 my-3">
            <h1 class="ps-3">New Item</h1>
            <hr />
            <form method="post" action="{{route('items.store')}}">
                @csrf
                <div class="row mb-3">
                    <div class="col">
                        <input
                            type="text"
                            class="form-control @error('name') is-invalid @enderror"
                            placeholder="Item"
                            name="name"
                            id="name"
                            value="{{old('name')}}"
                        />
                        <!--HELP: itt miert nem kerul kiirasra a hiba tenylegesen-->
                        @error('title')
                            <div class="invalid-feedback">
                                {{ $message }}
                            </div>
                        @enderror
                    </div>
                    <div class="col">
                        <input type="date"  @error('obtained') is-invalid @enderror id="obtained" name="obtained" value="{{old('obtained')}}">
                        @error('obtained')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                        @enderror
                    </div>
                </div>
                <div class="mb-3">
                    <!--HELP: a tobbi error miert nem jelenik meg?,   a descet nem tartja meg az allapottartas-->
                    <textarea class="form-control" @error('description') is-invalid @enderror name="description" id="description" cols="30" rows="10" placeholder="Item description" value="{{old('description')}}"></textarea>
                @error('description')
                    <div class="invalid-feedback">
                        {{ $message }}
                    </div>
                @enderror
                </div>
                <div class="mb-3">
                    <input type="file" class="form-control" @error('file') is-invalid @enderror id="file">
                    @error('file')
                    <div class="invalid-feedback">
                        {{ $message }}
                    </div>
                    @enderror
                </div>
                <div class="row">
                    <button type="submit" class="btn btn-primary">Save Item</button>
                </div>
            </form>
        </div>
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
            crossorigin="anonymous"
        ></script>

@endsection

