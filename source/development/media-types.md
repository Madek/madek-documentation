# Madek Media Types

Madek classifies uploaded files into the following `media_type`s,
for consistent handling in different parts of the system.

It is a mapping based on the `content_type` of a file
and expresses how different kinds of files are handled by the application.

The existence of a `Preview` with a certain `media_type` indicates
that the related `MediaFile` was successfully converted.

The `media_type` is persisted DB for efficient querying and in particular filtering.

<mark>
Currently, the mapping is very simple and does not match the actual app usage.
Any changes need to be migrated in the DB as well, therefore needs careful planning.
</mark>


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

Any "document" file (`content_type` starts with `application`)!

<mark>
This matches many very different kinds of files, e.g. compressed archives,
proprietary formats, test strings, PDF documents, etc.

However, **PDF** is the only type really handled. This should be added,
and 'document' removed.
Any more special types that will be handled in the future can than
simpy be added to the list (+migriating the exisiting values).
</mark>


# `other`

Any other file that is not matched by one of the definitions above.
