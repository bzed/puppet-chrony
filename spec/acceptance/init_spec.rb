require 'spec_helper_acceptance'

describe 'chrony class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = 'include chrony'
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('chrony') do
      it { is_expected.to be_installed }
    end

    service = case fact('os.family')
              when 'RedHat'
                'chronyd'
              else
                'chrony'
              end
    describe service(service) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
