$: << File.dirname(__FILE__)
require 'green_shoes'
require 'game'

module Nim
  class GUI
    def self.run
      Shoes.app :width => 360, :title => 'Nim Game' do
        #@bg = background green
        @game = Nim::Game.new(3,7)
        @seeds = @game.seeds
        @images = {}

        def encode img_index
          index = img_index
          @images.each do |i, image|
            q = image.select{|x| !x.hided }.count
            if q==0 and i < img_index
              index -= 1
            end
          end
          index
        end

        def decode img_index
          @images.each do |i, image|
            q = image.select{|x| !x.hided }.count
            if q==0 and i <= img_index
              img_index += 1
            end
          end
          img_index
        end

        def unhide_map 
          rms = []
          @images.each do |index, image|
            q = image.select{|x| !x.hided }.count
            rms << q 
          end
          rms
        end

        def action argv
          index = argv[0]
          taken_size = argv[1]
          x_index = decode index
          @images[x_index].each_with_index do |e, i|
            if i >= unhide_map[x_index] - taken_size
              e.hide
            end
          end
        end

        def setup
          flow do 
            0.upto(@seeds.count-1) do  |i|
              stack :width => 60, :margin_left => 100  do 
                @images[i] ||= []
                (@seeds[i]).times do 
                  para ''
                  @images[i] << (image 'img/ruby2.png')
                end	      
              end
            end
          end
        end
        setup

        @images.each_with_index do |k, img_index|
          v=k[1]
          v.each_with_index do |e, i|
            e.leave do |s|
              (i ... v.count).each do |index|
                v[index].path = 'img/ruby2.png'
              end
            end

            e.hover do |s|
              (i ... v.count).each do |index|
                v[index].path = 'img/ruby3.png'
              end
            end

            e.click do 
              (i ... v.count).each do |index|
                v[index].hide
              end
              q = (i...v.count).count
              x_index = encode(img_index)
              q = (i...unhide_map[img_index]).count
              @game.your_turn([x_index, q])
            end

            e.release do 
              if @seeds.empty? 
                alert('u win!')
                exit 
              end
              sleep 1
              argv = @game.ai_turn
              action argv
              if @seeds.empty? 
                alert('u lose!')
                exit 
              end
            end
          end
        end
      end
    end
  end
end

#Nim::GUI.run
