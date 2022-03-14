import 'package:unsplash_client/unsplash_client.dart';

main() async {
  final client = UnsplashClient(
    settings: const ClientSettings(
        credentials: AppCredentials(
      accessKey: 'ay92sRmqGd8NS494GL2CLx2aPGfSL4peI_WfVekJPuE',
      secretKey: 'ajxJC1q81mWSSvZUkDyJCzCU43rBFsr7yHpZNG9fnrY',
    )),
  );
  // Call `goAndGet` to execute the [Request] returned from `random`
// and throw an exception if the [Response] is not ok.
  final photos = await client.photos
      .random(
          count: 3, query: "greenery", orientation: PhotoOrientation.squarish)
      .goAndGet();

// The api returns a `Photo` which contains metadata about the photo and urls to download it.
  final photo = photos.first;
  final custom = photo.urls.raw.resizePhoto(width: 100, height: 100);
  print(custom);
}
