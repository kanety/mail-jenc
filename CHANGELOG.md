# CHANGELOG

## 1.3.1

* Fix mail version to < 2.9.0.

## 1.3.0

* Add patch to keep instances for `smtp_envelope_from` and `smtp_envelope_to`.

## 1.2.0

* Add current config which enables specified configs only in a block.

## 1.1.0

* Change supported mail version to 2.8.
* Drop support for ruby 2.3 and 2.4.

## 1.0.10

* Prefer header charset for encoding filename.
* Avoid encoding extra options to attachment header.
* Remove unnecessary charset from content type.

## 1.0.9

* Fix mail version to < 2.8.0.

## 1.0.8

* Don't separate escape sequence for b encoding.

## 1.0.7

* Fix deprecation warning for ruby 2.7.

## 1.0.6

* Remove rfc2231 key from options hash.

## 1.0.5

* Force us-ascii for only iso-2022-jp.

## 1.0.4

* Add rfc2231 option per mail and make false globally.
* Fix charset comparison.

## 1.0.3

* Fix for copy of headers.

## 1.0.2

* Fix unstructured field encoding.

## 1.0.1

* Fix encoding condition.

## 1.0.0

* First release.
