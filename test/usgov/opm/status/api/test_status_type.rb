# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::API::TestStatusType < Minitest::Test
  def setup
    @valid_status_type = {
      Id: "e3e3d34b-05ae-451a-b13a-93a1ac92dfe4", Name: "Open",
      Icon: "Open", Abbreviation: "Open", IsDefault: true
    }

    @invalid_status_type = {
      Id: "0000-1nv4l1d-st4tus-1d", Name: nil, Icon: nil,
      Abbreviation: nil, IsDefault: nil, Status: :invalid
    }
  end

  def test_that_statuses_are_defined_in_status_by_id_and_id_by_status
    USGov::OPM::Status::API::StatusType::STATUSES.each do |status|
      assert_equal(status[:status], USGov::OPM::Status::API::StatusType::STATUS_BY_ID[status[:id]])
      assert_equal(status[:id], USGov::OPM::Status::API::StatusType::ID_BY_STATUS[status[:status]])
    end

    assert_equal(USGov::OPM::Status::API::StatusType::STATUSES.count,
                 USGov::OPM::Status::API::StatusType::STATUS_BY_ID.count)
    assert_equal(USGov::OPM::Status::API::StatusType::STATUSES.count,
                 USGov::OPM::Status::API::StatusType::ID_BY_STATUS.count)
  end

  def test_that_status_type_can_be_instantiated
    status_type = USGov::OPM::Status::API::StatusType.new(@valid_status_type)
    assert_kind_of(USGov::OPM::Status::API::StatusType, status_type)
  end

  def test_that_status_type_instantiation_raises_error_if_nil
    assert_raises(USGov::OPM::Status::API::InvalidStatusTypeFormatError) do
      USGov::OPM::Status::API::StatusType.new(nil)
    end
  end

  def test_that_status_type_instantiation_raises_error_if_not_hash
    assert_raises(USGov::OPM::Status::API::InvalidStatusTypeFormatError) do
      USGov::OPM::Status::API::StatusType.new(@valid_status_type.to_a)
    end
  end

  def test_that_status_type_instantiation_raises_error_if_invalid_hash
    assert_raises(USGov::OPM::Status::API::InvalidStatusTypeFormatError) do
      USGov::OPM::Status::API::StatusType.new(@invalid_status_type)
    end
  end

  def test_that_status_type_instantiation_raises_error_if_get_status_from_id_returns_nil
    # TODO: Stub StatusType.get_status_from_id to return nil
    mock = Minitest::Mock.new
    mock.expect(:call, nil, [@valid_status_type[:Id]])

    USGov::OPM::Status::API::StatusType.stub(:get_status_from_id, mock) do
      assert_raises(USGov::OPM::Status::API::InvalidStatusTypeError) do
        USGov::OPM::Status::API::StatusType.new(@valid_status_type)
      end
    end

    assert_mock(mock)
  end

  def test_that_get_status_from_id_returns_all_known_statuses
    USGov::OPM::Status::API::StatusType::STATUSES.each do |known_status|
      status_from_id = USGov::OPM::Status::API::StatusType.get_status_from_id(known_status[:id])
      assert_equal(known_status[:status], status_from_id)
    end
  end

  def test_that_get_status_from_id_returns_nil_for_invalid_or_unknown_id
    status_from_id = USGov::OPM::Status::API::StatusType.get_status_from_id(@invalid_status_type[:Id])
    assert_nil(status_from_id)
  end

  def test_that_get_id_from_status_returns_all_known_ids
    USGov::OPM::Status::API::StatusType::STATUSES.each do |known_status|
      id_from_status = USGov::OPM::Status::API::StatusType.get_id_from_status(known_status[:status])
      assert_equal(known_status[:id], id_from_status)
    end
  end

  def test_that_get_id_from_status_returns_nil_for_invalid_or_unknown_status
    id_from_status = USGov::OPM::Status::API::StatusType.get_id_from_status(@invalid_status_type[:Status])
    assert_nil(id_from_status)
  end
end
