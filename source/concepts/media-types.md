# Madek Media Types

Madek classifies uploaded files into the following `media_type`s,
for consistent handling in different parts of the system.

It is a mapping based on the `content_type` of a file
and expresses how different kinds of files are handled by the application.

The existence of a `Preview` with a certain `media_type` indicates
that the related `MediaFile` was successfully converted.

The `media_type` is persisted in the DB for efficient querying and filtering
(`MediaFile` sets it in `before_create :set_media_type` from `content_type`).

The mapping is deliberately simple. Changing the enum requires a data migration
and coordinated app changes.

## Usage per Entity

- for `MediaEntry`
  - refers to the related `MediaFile`

- for `MediaFile`
  - refers to the **uploaded** file (itself)
  - persisted to DB

- for `Preview`
  - refers to the **converted** file
  - persisted to DB
  - ***can be different from `media_type` of related `MediaFile`(!)***,
    i.e. an image preview (frame) from a video file.


## List of Media Types

## `image`

Any image file (`content_type` starts with `image`).

## `audio`

Any audio file (`content_type` starts with `audio`).

## `video`

Any video file (`content_type` starts with `video`).

## `document`

Any "document" file (`content_type` starts with `application`).

That bucket includes archives, proprietary formats, and PDFs. In practice the
app special-cases **PDF** (`media_type == 'document' and extension == 'pdf'`)
for preview/representable-as-image behaviour. Renaming `document` → a dedicated
`pdf` (or similar) type remains an open product/migration decision.

## `other`

Any other file that is not matched by one of the definitions above.


## Image / thumbnail sizes

Bounding rectangle sizes used for image previews (thumbnails):

| Name            | Size  (bounding rectangle) |
|-----------------|----------------------------|
| `small` (*)     | 100 x 100                  |
| `small_125` (*) | 125 x 125                  |
| `medium`        | 300 x 300                  |
| `large`         | 620 x 620                  |
| `x_large`       | 1024 x 1024                |
| `grand` (**)    | 1280 x 1280                |
| `maximum`       | (original size)            |

(*) `small` and `small_125` are no longer generated starting with release 4.14.

(**) `grand` was introduced with release 4.14.
