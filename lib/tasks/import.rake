require 'csv'

RAILS_ENV = ENV["RAILS_ENV"] || "development"

namespace 'import' do

  desc "Import Departments"
  task 'departments' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Image::Base.where("imageable_type = 'Department'").destroy_all
      Department.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/departments.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      department = Department.find_by_name(row[:name]) || Department.new
      department.name = row[:name]
      department.description = row[:description]

      # Adding a client picture
      picture = nil
      image_name = row[:image_name]
      unless image_name.strip.blank?
        image_path = "db/import_data/#{RAILS_ENV}/images/departments/#{image_name}"
        if File.exists?(image_path)
          picture = department.build_picture
          picture.image = File.open(image_path)
        end
      end

      if department.valid? && (picture.blank? || picture.valid?)
        puts "#{department.name} saved".green if department.save!
      else
        puts "Error! #{department.errors.full_messages.to_sentence}".red
      end

    end
  end

  desc "Import Designations"
  task 'designations' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Image::Base.where("imageable_type = 'Designation'").destroy_all
      Designation.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/designations.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:title].blank?

      designation = Designation.find_by_title(row[:title]) || Designation.new
      designation.title = row[:title]
      designation.responsibilities = row[:responsibilities]

      # Adding a client picture
      picture = nil
      image_name = row[:image_name]
      unless image_name.strip.blank?
        image_path = "db/import_data/#{RAILS_ENV}/images/designations/#{image_name}"
        if File.exists?(image_path)
          picture = designation.build_picture
          picture.image = File.open(image_path)
        end
      end

      if designation.valid? && (picture.blank? || picture.valid?)
        puts "#{designation.title} saved".green if designation.save!
      else
        puts "Error! #{designation.errors.full_messages.to_sentence}".red
      end

    end
  end

  desc "Import Users"
  task 'users' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Image::Base.where("imageable_type = 'User'").destroy_all
      User.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/users.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers

    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      user = User.find_by_username(row[:username]) || User.new
      user.name = row[:name]
      user.username = row[:username]
      user.email = row[:email]
      user.phone = row[:phone]
      user.skype = row[:skype]
      user.linkedin = row[:linkedin]
      user.city = row[:city]
      user.state = row[:state]
      user.country = row[:country]
      user.user_type = row[:user_type]
      user.password = ConfigCenter::Defaults::PASSWORD
      user.password_confirmation = ConfigCenter::Defaults::PASSWORD

      designation = Designation.find_by_title(row[:designation])
      user.designation = designation

      department = Department.find_by_name(row[:department])
      user.department = department

      ## Adding a profile picture
      image_name = row[:image_name]
      profile_picture = nil
      unless image_name.strip.blank?
        image_path = "db/import_data/#{RAILS_ENV}/images/users/#{image_name}"
        if File.exists?(image_path)
          profile_picture = user.build_profile_picture
          profile_picture.image = File.open(image_path)
        else
          puts "#{image_path} doesn't exists".red
        end
      end

      if user.valid? && (profile_picture.blank? || profile_picture.valid?)
        puts "#{user.display_name} saved & approved".green if user.save! && user.approve!
      else
        puts "Error! #{user.errors.full_messages.to_sentence}".red
      end

    end
  end

  desc "Import all data in sequence"
  task 'all' => :environment do

    import_list = ["departments", "designations", "users"]

    import_list.each do |item|
      puts "Importing #{item.titleize}".yellow
      begin
        Rake::Task["import:#{item}"].invoke
      rescue Exception => e
        puts "Importing #{item.titleize} - Failed - #{e.message}".red
      end
    end

  end

end