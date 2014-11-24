require 'csv'

RAILS_ENV = ENV["RAILS_ENV"] || "development"

namespace 'import' do

  desc "Import AWS Instance Types"
  task 'aws_instance_types' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      AwsInstanceType.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/aws_instance_types.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol, col_sep: "\t"})
    headers = csv_table.headers
    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      aws_instance_type = AwsInstanceType.find_by_name(row[:name]) || AwsInstanceType.new
      aws_instance_type.name = row[:name]
      aws_instance_type.short_name = row[:short_name]
      aws_instance_type.description = row[:description]
      aws_instance_type.save

    end
  end

  desc "Import Operating Systems"
  task 'operating_systems' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Image::Base.where("imageable_type = 'OperatingSystem'").destroy_all
      OperatingSystem.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/operating_systems.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol, col_sep: "\t"})
    headers = csv_table.headers
    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:title].blank?

      os = OperatingSystem.find_by_title(row[:title]) || OperatingSystem.new
      os.name = row[:name]
      os.short_name = row[:short_name]
      os.description = row[:description]

      # Adding a client picture
      picture = nil
      image_name = row[:image_name]
      unless image_name.strip.blank?
        image_path = "db/import_data/#{RAILS_ENV}/images/operating_systems/#{image_name}"
        if File.exists?(image_path)
          picture = os.build_picture
          picture.image = File.open(image_path)
        end
      end

      if os.valid? && (picture.blank? || picture.valid?)
        puts "#{os.title} saved".green if os.save!
      else
        puts "Error! #{os.errors.full_messages.to_sentence}".red
      end

    end
  end

  desc "Import OS Versions"
  task 'os_versions' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      OsVersion.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/os_versions.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol, col_sep: "\t"})
    headers = csv_table.headers
    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:title].blank?

      osv = OsVersion.find_by_title(row[:title]) || OsVersion.new
      osv.name = row[:name]
      osv.version = row[:version]
      osv.description = row[:description]

      os = OsVersion.find_by_short_name(row[:os_short_name])
      osv.operating_system = os

      # Adding a picture
      picture = nil
      image_name = row[:image_name]
      unless image_name.strip.blank?
        image_path = "db/import_data/#{RAILS_ENV}/images/os_versions/#{image_name}"
        if File.exists?(image_path)
          picture = osv.build_picture
          picture.image = File.open(image_path)
        end
      end

      if osv.valid? && (picture.blank? || picture.valid?)
        puts "#{osv.title} saved".green if osv.save!
      else
        puts "Error! #{osv.errors.full_messages.to_sentence}".red
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
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol, col_sep: "\t"})
    headers = csv_table.headers

    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      user = User.find_by_username(row[:username]) || User.new
      user.name = row[:name]
      user.username = row[:username]
      user.email = row[:email]
      user.phone = row[:phone]
      user.designation = row[:designation]
      user.organisation = row[:organisation]
      user.about_me = row[:about_me]
      user.city = row[:city]
      user.state = row[:state]
      user.country = row[:country]
      user.user_type = row[:user_type]
      user.password = ConfigCenter::Defaults::PASSWORD
      user.password_confirmation = ConfigCenter::Defaults::PASSWORD

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

    import_list = ["aws_instance_types", "operating_systems", "os_versions", "users"]

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