require 'capybara/rspec'

describe 'Fetch Rewards Challenge' do
  before(:each) do
    visit 'http://ec2-54-208-152-154.compute-1.amazonaws.com/'
  end

  it 'should find a fake gold bar' do
    numbers = all(:xpath, '//body[1]/div[1]/div[1]/div[2]/button')
    numbers_array = []

    numbers.each do |number|
      numbers_array << number.text.to_i
    end

    combinations = numbers_array.combination(8).to_a

    start = 1
    combinations.each do |sequence|
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
        puts '------------------------------------'
        puts comparison
        sequence = sequence[0..3]
        puts '------------------------------------'

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
          puts comparison
          puts '------------------------------------'

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click

          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts comparison

          if comparison.include?('<')
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[0]}"
          else
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[1]}"
          end
          break
        elsif comparison.include?('>')
          start += 1

          puts comparison
          sequence = sequence[2..3]
          puts '------------------------------------'

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click

          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts comparison

          if comparison.include?('>')
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[1]}"
          else
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[0]}"
          end
          break
        end
      elsif comparison.include?('>')
        start += 1
        puts '------------------------------------'
        puts comparison
        sequence = sequence[4..7]
        puts '------------------------------------'

        find(:xpath, "//button[contains(text(),'Reset')]").click
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
          puts comparison
          puts '------------------------------------'

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click

          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts comparison

          if comparison.include?('<')
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[0]}"
          else
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[1]}"
          end
          break
        elsif comparison.include?('>')
          start += 1
          puts comparison
          puts '------------------------------------'
          sequence = sequence[2..3]

          find(:xpath, "//input[@id='left_0']").set(sequence[0])
          find(:xpath, "//input[@id='right_0']").set(sequence[1])
          find(:xpath, "//button[@id='weigh']").click
          sleep 2
          find(:xpath, "//button[contains(text(),'Reset')]").click

          comparison = find(:xpath, "/html[1]/body[1]/div[1]/div[1]/div[1]/div[5]/ol[1]/li[#{start}]").text
          puts comparison

          if comparison.include?('>')
            find(:xpath, "//button[@id='coin_#{sequence[1]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[1]}"
          else
            find(:xpath, "//button[@id='coin_#{sequence[0]}']").click
            alert_message = page.driver.browser.switch_to.alert.text
            expect(alert_message).to eq 'Yay! You find it!'
            puts '------------------------------------'
            puts alert_message
            puts "The fake bar is #{sequence[0]}"
          end
          break
        end
      else
        puts comparison
        array_sum = sequence[0..7]
        array_sum = array_sum.sum
        fake_bar = 36 - array_sum

        find(:xpath, "//button[@id='coin_#{fake_bar}']").click
        alert_message = page.driver.browser.switch_to.alert.text
        expect(alert_message).to eq 'Yay! You find it!'
        puts '------------------------------------'
        puts alert_message
        puts "The fake bar is #{fake_bar}"
        break
      end
      start += 1
    end
  end
end
