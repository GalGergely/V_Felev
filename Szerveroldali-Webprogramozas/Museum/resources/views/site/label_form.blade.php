@extends('layouts.layout')

@section('title', @isset($label) ? 'Edit Label' : 'New Label')

@section('content')
        <div class="container-fluid px-5 my-3">
            <h1 class="ps-3">{{isset($label) ? 'Edit Label' : 'New Label'}}</h1>
            <hr />
            <form method="post" action="{{ isset($label) ? route('labels.update', ['label' => $label->id]) : route('labels.store')}}">
                @csrf
                @isset($label)
                    @method('put')
                @endisset
                <div class="row mb-3">
                    <div class="col">
                        <input
                            type="text"
                            class="form-control @error('name') is-invalid @enderror"
                            placeholder="Label Name"
                            name="name"
                            id="name"
                            value="{{old('name', $label->name ?? '')}}"
                        />
                        @error('name')
                            <div class="invalid-feedback">
                                {{ $message }}
                            </div>
                        @enderror
                    </div>
                    <div class="col">
                            <select class="form-select" name="display" id="display">
                                <option value="1" {{ old('display', $label->display ?? '') == 1 ? 'selected' : '' }} >Displayable</option>
                                <option value="0" {{ old('display', $label->display ?? '') == 0 ? 'selected' : '' }}>Not displayable</option>
                            </select>
                        @error('display')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                        @enderror
                    </div>
                </div>
                <div class="mb-3">
                    <label for="color">Label Color: </label>
                    <input type="color"  @error('color') is-invalid @enderror id="color" name="color"value="{{old('color', $label->color ?? '')}}">
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

