@extends('layouts.app')

@section('content')
    @if($errors->any())
        <p style="color: red">{{$errors->first()}}</p>
    @endif
    <form method="POST" action="{{ route('save_equipement', $equipement->id) }}" id="items">
        @csrf

        @foreach($emplacements as $emplacement)
            <label for="{{ $emplacement->libelle }}">{{ $emplacement->libelle }}</label>
            <select name="{{ $emplacement->libelle }}" id="{{ $emplacement->libelle }}">
                @if(isset($equipes[$emplacement->libelle]))
                    <option value="{{$equipes[$emplacement->libelle]->id}}"
                            selected="selected">{{$equipes[$emplacement->libelle]->libelle}}</option>
                @endif
                @foreach($items[$emplacement->libelle] as $item)
                    <option value="{{$item->id}}">{{$item->libelle}}</option>
                @endforeach
            </select>
            <br>
            @if($emplacement->libelle == 'Anneau')
                <label for="Anneau1">Anneau 2</label>
                <select name="Anneau1" id="Anneau1">
                    @if(isset($equipes["Anneau1"]))
                        <option value="{{$equipes["Anneau1"]->id}}"
                                selected="selected">{{$equipes["Anneau1"]->libelle}}</option>
                    @endif
                    @foreach($items[$emplacement->libelle] as $item)

                        <option value="{{$item->id}}">{{$item->libelle}}</option>
                    @endforeach
                </select>
                <br>
            @elseif($emplacement->libelle == 'Dofus')
                @for($i = 1; $i < 6; $i++)
                    <label for="{{ $emplacement->libelle . $i }}">{{ $emplacement->libelle . $i }}</label>
                    <select name="{{ $emplacement->libelle . $i }}" id="{{ $emplacement->libelle . $i }}">
                        @if(isset($equipes[$emplacement->libelle . $i]))
                            <option value="{{$equipes[$emplacement->libelle . $i]->id}}"
                                    selected="selected">{{$equipes[$emplacement->libelle . $i]->libelle}}</option>
                        @endif
                        @foreach($items[$emplacement->libelle] as $item)
                            <option value="{{$item->id}}">{{$item->libelle}}</option>
                        @endforeach
                    </select>
                    <br>
                @endfor
            @endif
        @endforeach

    </form>
    <button form="items">Sauvegarder</button>
@endsection
