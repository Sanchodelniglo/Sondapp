puts "Starting seed"
sleep(1)
puts "Destroying Probings & Users"

Probing.destroy_all
User.destroy_all
10.times do
  print "."
  sleep(0.5)
end
puts "."

puts "Probings & Users Destroyed"
sleep(1)
puts "Creating Romain & Charles-Henri"
10.times do
  print "."
  sleep(0.5)
end
puts "."
romain = User.create!(
                      email:"batman@gotham.com",
                      password:"secret",
                      first_name:"Romain",
                      last_name: "Grossard",
                      phone_number:"0689525415",
                      pathology:"Syndrome de la queue de cheval + Vessie acontractile + énorme teub",
                      genre:"hermaphrodite",
                      age:31
                      )
charles_henri = User.create!(
                      email:"c.poniard@gmail.com",
                      password:"secret",
                      first_name:"Charles-Henri",
                      last_name: "Poniard",
                      phone_number:"0789281430",
                      pathology:"stressé du bulbe + double-anus",
                      genre:"shemale",
                      age:29
                      )

puts "Romain & Charles-Henri created"
puts "Creating Probings"

300.times do
  Probing.create!(
    user_id: [romain.id, charles_henri.id].sample,
    quantity: %w(100 200 300 400 500 600 700 800 1000).sample.to_i,
    hydratation: %w(100 200 300 400 500 600 700 800 1000 1100 1200).sample.to_i,
    quality: %w(R-A-S Infection).sample,
    fleed: rand(0..4),
    collect_methode: Probing.where(:user_id == romain.id) ? "auto-sondage" : "normale"
    )
end
10.times do
  print "."
  sleep(0.5)
end
puts "."
puts "Probings Created"
puts "Wait For It"
10.times do
  print "."
  sleep(0.5)
end
puts"."
puts "Seeding Finished Mother F*cker!!"
