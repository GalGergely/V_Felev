@extends('layouts.layout')

@section('title', 'New Label')

@section('content')
        <div class="container-fluid px-5 my-3">
            <h1 class="ps-3">New Label</h1>
            <hr />
            <form method="post" action="{{route('labels.store')}}">
                @csrf
                <div class="row mb-3">
                    <div class="col">
                        <input
                            type="text"
                            class="form-control @error('name') is-invalid @enderror"
                            placeholder="Label Name"
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
                        <!--HELP:miert nem tartja az allapotot?-->
                            <select class="form-select" name="display" id="display">
                                <option value="0" {{ old('display', $labels->display ?? '') == 0 ? 'selected' : '' }} >Displayable</option>
                                <option value="1" {{ old('display', $labels->display ?? '') == 0 ? 'selected' : '' }}>Not displayable</option>
                            </select>
                        @error('display')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                        @enderror
                    </div>
                </div>
                <div class="mb-3">
                    <!--HELP: a tobbi error miert nem jelenik meg?,   a descet nem tartja meg az allapottartas-->
                    <label for="color">Label Color: </label>
                    <input type="color"  @error('color') is-invalid @enderror id="color" name="color" value="{{old('color')}}">
                @error('description')
                    <div class="invalid-feedback">
                        {{ $message }}
                    </div>
                @enderror
                </div>
                <div class="row">
                    <button type="submit" class="btn btn-primary">Save label</button>
                </div>
            </form>
        </div>
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
            crossorigin="anonymous"
        ></script>

@endsection

