import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitialState());

  void navigateToChooseGame() {
    emit(MainPageChooseGameState());
  }

  void navigateToMainPage() {
    emit(MainPageInitialState());
  }

  void navigateToArtifacts() {
    emit(MainPageArtifactsState());
  }

   void navigateToFinderGame() {
    emit(MainPageFinderState());
  }

  void navigateToSettings() {
    emit(MainPageSettingsState());
  }

  void navigateToArtifactDetails({
    required String name,
    required String description,
    required ArtifactModel model,
    required String imagePath,
  }) {
    emit(MainPageArtefactDetailsState(
      name: name,
      model: model,
      description: description,
      imagePath: imagePath,
    ));
  }
}
