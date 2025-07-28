module RailsSettings
  module Fields
    class FileField < ::RailsSettings::Fields::Base
      def deserialize(value)
        return nil if value.nil?

        # Return the attached file if it exists
        parent_record = parent.find_by(var: key)
        return parent_record.send(attachment_name) if parent_record&.send(attachment_name)&.attached?

        nil
      end

      def serialize(value)
        # Store the file attachment
        parent_record = parent.find_by(var: key) || parent.new(var: key)

        if value.respond_to?(:tempfile) || value.is_a?(ActionDispatch::Http::UploadedFile)
          parent_record.send(attachment_name).attach(value)
        elsif value.is_a?(ActiveStorage::Attached::One)
          parent_record.send(attachment_name).attach(value.blob)
        elsif value.is_a?(ActiveStorage::Blob)
          parent_record.send(attachment_name).attach(value)
        end

        # Save the record
        parent_record.save!

        # Return a reference to indicate we have a file
        "file_attached"
      end

      def read
        # For file fields, always return the attachment object, not the stored value
        stored_value = saved_value
        return nil if stored_value.nil?

        # Return the attached file if it exists
        parent_record = parent.find_by(var: key)
        if parent_record&.send(attachment_name)&.attached?
          return parent_record.send(attachment_name)
        end

        nil
      end

      private

      def attachment_name
        "file_#{key}"
      end
    end
  end
end
