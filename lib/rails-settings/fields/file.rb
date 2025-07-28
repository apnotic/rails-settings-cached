module RailsSettings
  module Fields
    class File < ::RailsSettings::Fields::Base
      def deserialize(value)
        return nil if value.nil?

        # Return the attached file if it exists
        parent_record = parent.find_by(var: key)
        return parent_record.file if parent_record&.file&.attached?

        nil
      end

      def serialize(value)
        # Store the file attachment
        parent_record = parent.find_by(var: key) || parent.new(var: key)

        if value.respond_to?(:tempfile) || value.is_a?(ActionDispatch::Http::UploadedFile)
          parent_record.file.attach(value)
        elsif value.is_a?(ActiveStorage::Attached::One)
          parent_record.file.attach(value.blob)
        elsif value.is_a?(ActiveStorage::Blob)
          parent_record.file.attach(value)
        end

        # Return a reference to indicate we have a file
        "file_attached"
      end
    end
  end
end
