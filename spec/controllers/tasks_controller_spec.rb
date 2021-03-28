require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:all) do
    Task.destroy_all
    User.destroy_all
    @user = User.create(email: 'test@email.com',
                        admin: false,
                        password: 'track-time',
                        password_confirmation: 'track-time')
    @admin = User.create(email: 'admin@email.com',
                         admin: true,
                         password: 'track-time',
                         password_confirmation: 'track-time')
    5.times do
      password = Faker::Lorem.characters(number: 8)

      User.create(
        email: Faker::Internet.unique.email,
        admin: Faker::Boolean.boolean(true_ratio: 0.2),
        password: password,
        password_confirmation: password
      )
    end

    10.times do
      User.first.tasks.create(
        comment: Faker::Lorem.sentence,
        time_type: %w[Meeting Study Exercise].second,
        start_time: Faker::Time.between(from: DateTime.new(2012), to: DateTime.new(2013)),
        end_time: Faker::Time.between(from: DateTime.new(2014), to: DateTime.new(2015))
      )
    end

    5.times do
      User.second.tasks.create(
        comment: Faker::Lorem.sentence,
        time_type: %w[Meeting Study Exercise].first,
        start_time: Faker::Time.between(from: DateTime.new(2022), to: DateTime.new(2023)),
        end_time: Faker::Time.between(from: DateTime.new(2024), to: DateTime.new(2025))
      )
    end
  end

  context 'when there is no any user signed in' do
    describe 'any action' do
      it "isn't allowed to be accessed" do
        get :index
        expect(@controller.instance_variable_get(:@tasks)).to eq nil

        get :new
        expect(@controller.instance_variable_get(:@task)).to eq nil

        post :create
        expect(@controller.instance_variable_get(:@_params)).to eq nil
      end
    end
  end

  context 'when there is a user signed in' do
    context 'when there is a user signed in' do
      before(:each) { sign_in @user }

      describe 'new action' do
        it 'will return new task ' do
          get :new
          expect(@controller.instance_variable_get(:@task)).not_to eq nil
        end
      end

      describe 'create action' do
        it 'will create a task ' do
          expect(Task.all.size).to eq 15

          post :create, params: {
            task: {
              comment: Faker::Lorem.sentence,
              time_type: %w[Meeting Study Exercise].sample,
              start_time: Faker::Time.between(from: DateTime.now - 14, to: DateTime.now - 7),
              end_time: Faker::Time.between(from: DateTime.now - 7, to: DateTime.now)
            }
          }
          expect(Task.all.size).to eq 16
        end
      end
    end

    context 'when there is a user signed in and the user is not an admin' do
      describe 'index action' do
        it "isn't allowed to be accessed " do
          sign_in @user
          get :index
          expect(@controller.instance_variable_get(:@tasks)).to eq nil
        end
      end
    end

    context 'when there is a user signed in and the user is an admin' do
      describe 'index action' do
        it 'will return all tasks if there is no any filter' do
          sign_in @admin
          get :index
          expect(@controller.instance_variable_get(:@tasks).size).to eq 15
        end

        it 'will return filtered tasks if there is any filter' do
          default_params = {
            'users_id' => [''],
            'time_type' => '',
            'start_time(1i)' => '2006', 'start_time(2i)' => '1', 'start_time(3i)' => '1', 'start_time(4i)' => '00', 'start_time(5i)' => '00',
            'end_time(1i)' => '2026', 'end_time(2i)' => '1', 'end_time(3i)' => '1', 'end_time(4i)' => '00', 'end_time(5i)' => '00',
            'filter' => 'Filter'
          }

          expect(Task.all.size).to eq 15

          sign_in @admin

          get :index, params: {
            **default_params,
            'users_id' => ['', User.first.id]
          }
          expect(@controller.instance_variable_get(:@tasks).size).to eq 10

          get :index, params: {
            **default_params,
            'start_time(1i)' => '2016'
          }
          expect(@controller.instance_variable_get(:@tasks).size).to eq 5

          get :index, params: {
            **default_params,
            'end_time(1i)' => '2016'
          }
          expect(@controller.instance_variable_get(:@tasks).size).to eq 10

          get :index, params: {
            **default_params,
            'time_type' => 'Meeting'
          }
          expect(@controller.instance_variable_get(:@tasks).size).to eq 5
        end
      end
    end
  end
end
