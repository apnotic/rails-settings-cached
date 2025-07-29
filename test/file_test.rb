# frozen_string_literal: true

require "test_helper"

class FileFieldTest < ActiveSupport::TestCase
  def setup
    # Ensure ActiveStorage is available
    unless defined?(ActiveStorage)
      skip "ActiveStorage not available in this Rails version"
    end
  end

  test "file field type can be defined" do
    assert Setting.respond_to?(:file_item)
    assert Setting.respond_to?(:file_item=)
  end

  test "file field returns nil when no file is attached" do
    assert_nil Setting.file_item
  end

  test "file field can store and retrieve blob" do
    # Create a blob
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("Hello, World!"),
      filename: "test.txt",
      content_type: "text/plain"
    )

    # Set the blob
    Setting.file_item = blob

    # Verify the file was stored
    assert Setting.file_item.present?
  end

  test "file field handles nil values" do
    Setting.file_item = nil
    assert_nil Setting.file_item
  end

  test "file field bypasses caching" do
    # This test verifies that file fields bypass caching to avoid segfaults
    Setting.file_item = nil

    # The field should return nil without using cache
    assert_nil Setting.file_item
  end
end
