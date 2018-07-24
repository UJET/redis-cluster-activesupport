require 'spec_helper'

# rubocop:disable Metrics/BlockLength

describe ::ActiveSupport::Cache::RedisElasticacheStore do
  let(:options) { {} }

  subject { described_class.new(options) }

  describe '#delete_matched' do
    it 'returns false when a known error is raised' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'LOADING Redis is loading the dataset in memory'
      )
      expect(subject.delete_matched('test')).to eq(nil)
    end

    it 'raises when an unknown command error occurs' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'Yolo dude!'
      )
      expect { subject.delete_matched('test') }.to raise_error('Yolo dude!')
    end

    context 'custom error' do
      let(:options) { { ignored_command_errors: ['Faked You Out'] } }

      it 'returns false when a known error is raised' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'Faked You Out'
        )
        expect(subject.delete_matched('test')).to eq(nil)
      end
    end

    context 'raise_errors? is enabled' do
      let(:options) { { raise_errors: true } }

      it 'raises an error' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'LOADING Redis is loading the dataset in memory'
        )
        expect { subject.delete_matched('test') }.to raise_error(
          'LOADING Redis is loading the dataset in memory'
        )
      end
    end
  end

  describe '#fetch_multi' do
    it 'returns false when a known error is raised' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'LOADING Redis is loading the dataset in memory'
      )
      expect(subject.fetch_multi('test')).to eq(nil)
    end

    it 'raises when an unknown command error occurs' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'Yolo dude!'
      )
      expect { subject.fetch_multi('test') }.to raise_error('Yolo dude!')
    end

    context 'custom error' do
      let(:options) { { ignored_command_errors: ['Faked You Out'] } }

      it 'returns false when a known error is raised' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'Faked You Out'
        )
        expect(subject.fetch_multi('test')).to eq(nil)
      end
    end

    context 'raise_errors? is enabled' do
      let(:options) { { raise_errors: true } }

      it 'raises an error' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'LOADING Redis is loading the dataset in memory'
        )
        expect { subject.fetch_multi('test') }.to raise_error(
          'LOADING Redis is loading the dataset in memory'
        )
      end
    end
  end

  describe '#increment' do
    let(:fake_client) { Redis.new }
    before { allow(subject).to receive(:with).and_yield(fake_client) }

    it 'only returns the new value after being incremented with ttl' do
      expect(subject.increment('testing', 1, expires_in: 5.minutes)).to eq(1)
      expect(subject.increment('testing', 5, expires_in: 5.minutes)).to eq(6)
    end

    it 'can increment without a ttl' do
      expect(fake_client).to_not receive(:pipelined).and_call_original
      expect(subject.increment('testing')).to eq(1)
    end

    it 'can increment with a ttl' do
      expect(fake_client).to receive(:pipelined).and_yield
      expect(fake_client).to receive(:incrby).with('testing', 1)
      expect(fake_client).to receive(:expire).with('testing', 300)
      subject.increment('testing', 1, expires_in: 5.minutes)
    end
  end

  describe '#write_entry' do
    it 'returns false when a known error is raised' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'LOADING Redis is loading the dataset in memory'
      )
      expect(subject.write('test', 'yolo')).to eq(false)
    end

    it 'raises when an unknown command error occurs' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'Yolo dude!'
      )
      expect { subject.write('test', 'yolo') }.to raise_error('Yolo dude!')
    end

    context 'custom error' do
      let(:options) { {:ignored_command_errors => ['Faked You Out']} }

      it 'returns false when a known error is raised' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'Faked You Out'
        )
        expect(subject.write('test', 'yolo')).to eq(false)
      end
    end

    context 'raise_errors? is enabled' do
      let(:options) { { raise_errors: true } }

      it 'raises an error' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'LOADING Redis is loading the dataset in memory'
        )
        expect { subject.write('test', 'yolo') }.to raise_error(
          'LOADING Redis is loading the dataset in memory'
        )
      end
    end
  end

  describe '#read_entry' do
    it 'returns false when a known error is raised' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'LOADING Redis is loading the dataset in memory'
      )
      expect(subject.read('test')).to eq(nil)
    end

    it 'raises when an unknown command error occurs' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'Yolo dude!'
      )
      expect { subject.read('test') }.to raise_error('Yolo dude!')
    end

    context 'custom error' do
      let(:options) { { ignored_command_errors: ['Faked You Out'] } }

      it 'returns false when a known error is raised' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'Faked You Out'
        )
        expect(subject.read('test')).to eq(nil)
      end
    end

    context 'raise_errors? is enabled' do
      let(:options) { { raise_errors: true } }

      it 'raises an error' do
        allow(subject).to receive(:with).and_raise(
          ::Redis::CommandError,
          'LOADING Redis is loading the dataset in memory'
        )
        expect { subject.read('test') }.to raise_error(
          'LOADING Redis is loading the dataset in memory'
        )
      end
    end
  end

  describe '#delete_entry' do
    it 'returns false when a known error is raised' do
      allow(subject).to receive(:with).and_raise(
        ::Redis::CommandError,
        'LOADING Redis is loading the dataset in memory'
      )
      expect(subject.delete('test')).to eq(false)
    end

    it 'raises when an unknown command error occurs' do
      allow(subject).to receive(:with).and_raise(::Redis::CommandError, 'Yolo dude!')
      expect { subject.delete('test') }.to raise_error('Yolo dude!')
    end

    context 'custom error' do
      let(:options) { {:ignored_command_errors => ['Faked You Out']} }

      it 'returns false when a known error is raised' do
        allow(subject).to receive(:with).and_raise(::Redis::CommandError, 'Faked You Out')
        expect(subject.delete('test')).to eq(false)
      end
    end

    context 'raise_errors? is enabled' do
      let(:options) { {:raise_errors => true} }

      it 'raises an error' do
        allow(subject).to receive(:with).and_raise(::Redis::CommandError, 'LOADING Redis is loading the dataset in memory')
        expect { subject.delete('test') }.to raise_error('LOADING Redis is loading the dataset in memory')
      end
    end
  end
end

# rubocop:enable
