# frozen_string_literal: true

require "test_helper"

class FileTest < ActiveSupport::TestCase
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

  test "file field can store and retrieve uploaded file" do
    # Create a mock uploaded file
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: Tempfile.new("test"),
      filename: "test.txt",
      type: "text/plain"
    )

    # Write some content to the temp file
    uploaded_file.tempfile.write("Hello, World!")
    uploaded_file.tempfile.rewind

    # Set the file
    Setting.file_item = uploaded_file

    # Verify the file was attached
    assert Setting.file_item.attached?
    assert_equal "test.txt", Setting.file_item.filename.to_s
    assert_equal "text/plain", Setting.file_item.content_type
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

    # Verify the file was attached
    assert Setting.file_item.attached?
    assert_equal "test.txt", Setting.file_item.filename.to_s
    assert_equal "text/plain", Setting.file_item.content_type
  end

  test "file field can store and retrieve attached file" do
    # Create a blob first
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("Hello, World!"),
      filename: "test.txt",
      content_type: "text/plain"
    )

    # Create an attached file
    attached_file = ActiveStorage::Attached::One.new("file", Setting.new)
    attached_file.attach(blob)

    # Set the attached file
    Setting.file_item = attached_file

    # Verify the file was attached
    assert Setting.file_item.attached?
    assert_equal "test.txt", Setting.file_item.filename.to_s
  end

  test "file field handles nil values" do
    Setting.file_item = nil
    assert_nil Setting.file_item
  end

  test "file field can be used in scopes" do
    Setting.scope :uploads do
      field :logo, type: :file
    end

    assert Setting.respond_to?(:logo)
    assert Setting.respond_to?(:logo=)
  end
end
