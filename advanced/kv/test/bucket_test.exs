defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  # Creates a new bucket as a setup of the tests
  setup do
    bucket = start_supervised!(KV.Bucket)
    %{bucket: bucket}
  end

  # Creates a new test
  test "stores values by key", %{bucket: bucket} do
    # Tries to get a bucket
    assert KV.Bucket.get_by_key(bucket, "milk") == nil

    # Tries to update the bucket above and get it
    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get_by_key(bucket, "milk") == 3

    # Trie to get all the bucket
    assert KV.Bucket.get(bucket) == %{"milk" => 3}

    # Deleting a value by key
    assert KV.Bucket.delete(bucket, "milk") == 3
  end
end
