require 'capybara/rspec'

describe 'Fetch Rewards Challenge' do
  before(:each) do
    visit 'http://ec2-54-208-152-154.compute-1.amazonaws.com/'
  end

  it 'should do a task' do
    numbers = all(:xpath, '/html[1]/body[1]/div[1]/div[1]/div[2]/button')
    numbers_array = []

    numbers.each do |number|
      numbers_array << number.text.to_i
    end

    combinations = numbers_array.combination(8).to_a

    start = 1
    combinations.each do |sequence|
      # puts "#{sequence[0]},#{sequence[1]},#{sequence[2]},#{sequence[3]}"

      find(:xpath, "//input[@id='left_0']").set(sequence[0])
      find(:xpath, "//input[@id='left_1']").set(sequence[1])
      find(:xpath, "//input[@id='left_2']").set(sequence[2])
      find(:xpath, "//input[@id='left_3']").set(sequence[3])
      find(:xpath, "//input[@id='right_0']").set(sequence[4])
      find(:xpath, "//input[@id='right_1']").set(sequence[5])
      find(:xpath, "//input[@id='right_2']").set(sequence[6])
      find(:xpath, "//input[@id='right_3']").set(sequence[7])
      find(:xpath, "//button[@id='weigh']").click
      sleep 2
      find(:xpath, "//button[contains(text(),'Reset')]").click

      comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text

      if comparison.include?('<')
        start += 1
        puts 'found it'
        puts comparison
        sequence = sequence[0..3]
        puts sequence
        puts '--------------------------------------------------'
        find(:xpath, "//input[@id='left_0']").set(sequence[0])
        find(:xpath, "//input[@id='left_1']").set(sequence[1])
        find(:xpath, "//input[@id='right_0']").set(sequence[2])
        find(:xpath, "//input[@id='right_1']").set(sequence[3])
        find(:xpath, "//button[@id='weigh']").click
        sleep 2
        find(:xpath, "//button[contains(text(),'Reset')]").click
        comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
        if comparison.include?('<')
          start += 1
          puts 'found it'
          puts comparison
          puts sequence[0..1]
          puts '--------------------------------------------------'

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click
          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts 'found it'
          puts comparison
          if comparison.include?('<')
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
          else
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
          end
          break
        elsif comparison.include?('>')
          start += 1
          puts 'found it'
          puts sequence[2..3]
          puts comparison
          sequence = sequence[2..3]
          puts '------------------------------------'

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click
          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts 'found it'
          puts comparison

          if comparison.include?('>')
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
          else
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
          end
          break
        end
      elsif comparison.include?('>')
        start += 1
        puts 'found it'
        puts comparison
        sequence = sequence[4..7]
        puts sequence
        # break
        find(:xpath, "//button[contains(text(),'Reset')]").click
        # puts '--------------------------------------------------'
        find(:xpath, "//input[@id='left_0']").set(sequence[0])
        find(:xpath, "//input[@id='left_1']").set(sequence[1])
        find(:xpath, "//input[@id='right_0']").set(sequence[2])
        find(:xpath, "//input[@id='right_1']").set(sequence[3])
        find(:xpath, "//button[@id='weigh']").click

        sleep 2
        find(:xpath, "//button[contains(text(),'Reset')]").click
        comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
        if comparison.include?('<')
          start += 1
          puts 'found it'
          puts comparison
          sequence = sequence[0..1]
          puts '------------------------------------'

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click
          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts 'found it'
          puts comparison

          if comparison.include?('<')
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
          else
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
          end
          break
        elsif comparison.include?('>')
          start += 1
          puts 'found it'
          puts sequence[6..7]
          puts comparison
          puts '------------------------------------'
          sequence = sequence[2..3]

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click
          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts 'found it'
          puts comparison

          if comparison.include?('>')
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
          else
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
          end
          break
        end
      else
        # comparison.include?('=')
        # elsif comparison.include?('=')
        array_sum = sequence[0..7]
        array_sum = array_sum.sum
        puts array_sum

        fake_bar = 36 - array_sum
        puts "fake bar = #{fake_bar}"
        # 36 mimnus combination
        find(:xpath, "//button[@id='coin_#{fake_bar}']").click
        break
      end
      start += 1
    end
    sleep 30
  end
end
