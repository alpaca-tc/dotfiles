
require 'refe/database'


class FunctionCompletionTester < RUNIT::TestCase

  testme!

  def setup
    @table ||= ReFe::FunctionTable.new(nil,
                   ReFe::CompletionTable.new('data/function_comp', false))
    @all ||= File.readlines('data/function_comp').map {|n| n.strip }.sort
  end

  def complete( *args )
    list = @table.complete(args)
    assert_instance_of Array, list
    assert_equal false, (list.size == 0), "list.size == 0"
    list.sort
  end

  def test_complete
    assert_equal %w(
        rb_stat_init rb_stat_ino rb_stat_inspect rb_str_include
        rb_str_index rb_str_index_m rb_str_init rb_str_insert
        rb_str_inspect rb_str_intern rb_struct_initialize
        rb_struct_inspect rb_struct_iv_get
        ).sort,
        complete('r', 's', 'i')
    assert_equal %w(
        rb_stat_init rb_stat_ino rb_stat_inspect rb_str_include
        rb_str_index rb_str_index_m rb_str_init rb_str_insert
        rb_str_inspect rb_str_intern rb_struct_initialize
        rb_struct_inspect rb_struct_iv_get
        ).sort,
        complete('r', 'st', 'i')
    assert_equal %w(
        rb_stat_init rb_stat_ino rb_stat_inspect rb_str_include
        rb_str_index rb_str_index_m rb_str_init rb_str_insert
        rb_str_inspect rb_str_intern rb_struct_initialize
        rb_struct_inspect
        ).sort,
        complete('r', 'st', 'in')
    assert_equal %w(
        rb_str_include
        rb_str_index rb_str_index_m rb_str_init rb_str_insert
        rb_str_inspect rb_str_intern rb_struct_initialize
        rb_struct_inspect
        ).sort,
        complete('r', 'str', 'in')
    assert_equal %w(
        rb_str_insert rb_str_inspect rb_struct_inspect
        ).sort,
        complete('r', 'str', 'ins')
    assert_equal %w(
        rb_str_index rb_str_index_m
        ).sort,
        complete('r', 'str', 'ind')
    assert_equal %w(
        rb_str_index
        ).sort,
        complete('r', 'str', 'index')
  end

  def test_extent
    assert_equal @all, complete()
    assert_equal @all, complete('')
  end

  def test_underbar
    ok = %w(
        rb_String rb_str2cstr rb_str2inum rb_str_append rb_str_aref
        rb_str_aref_m rb_str_aset rb_str_aset_m rb_str_associate
        rb_str_associated rb_str_buf_append rb_str_buf_cat rb_str_buf_cat2
        rb_str_buf_new rb_str_buf_new2 rb_str_capitalize
        rb_str_capitalize_bang rb_str_casecmp rb_str_cat rb_str_cat2
        rb_str_center rb_str_chomp rb_str_chomp_bang rb_str_chop
        rb_str_chop_bang rb_str_cmp rb_str_cmp_m rb_str_concat rb_str_count
        rb_str_crypt rb_str_delete rb_str_delete_bang rb_str_downcase
        rb_str_downcase_bang rb_str_dump rb_str_dup rb_str_dup_frozen
        rb_str_each_byte rb_str_each_line rb_str_empty rb_str_eql
        rb_str_equal rb_str_format rb_str_freeze rb_str_gsub rb_str_gsub_bang
        rb_str_hash rb_str_hash_m rb_str_hex rb_str_include rb_str_index
        rb_str_index_m rb_str_init rb_str_insert rb_str_inspect rb_str_intern
        rb_str_length rb_str_ljust rb_str_lstrip rb_str_lstrip_bang
        rb_str_match rb_str_match2 rb_str_match_m rb_str_modify rb_str_new
        rb_str_new2 rb_str_new3 rb_str_new4 rb_str_new5 rb_str_oct
        rb_str_plus rb_str_replace rb_str_resize rb_str_reverse
        rb_str_reverse_bang rb_str_rindex rb_str_rindex_m
        rb_str_rjust rb_str_rstrip rb_str_rstrip_bang rb_str_scan
        rb_str_setter rb_str_shared_replace rb_str_slice_bang
        rb_str_split rb_str_split_m rb_str_squeeze rb_str_squeeze_bang
        rb_str_strip rb_str_strip_bang rb_str_sub rb_str_sub_bang
        rb_str_subpat rb_str_subpat_set rb_str_substr rb_str_succ
        rb_str_succ_bang rb_str_sum rb_str_swapcase rb_str_swapcase_bang
        rb_str_times rb_str_to_dbl rb_str_to_f rb_str_to_i rb_str_to_inum
        rb_str_to_s rb_str_to_str rb_str_tr rb_str_tr_bang rb_str_tr_s
        rb_str_tr_s_bang rb_str_upcase rb_str_upcase_bang rb_str_update
        rb_str_upto rb_str_upto_m

        rb_strftime rb_string_value rb_string_value_ptr

        rb_struct_alloc rb_struct_aref rb_struct_aref_id rb_struct_aset
        rb_struct_aset_id rb_struct_copy_object rb_struct_define
        rb_struct_each rb_struct_each_pair rb_struct_equal
        rb_struct_getmember rb_struct_initialize rb_struct_inspect
        rb_struct_iv_get rb_struct_members rb_struct_modify rb_struct_new
        rb_struct_ref rb_struct_s_def rb_struct_s_members rb_struct_select
        rb_struct_set rb_struct_size rb_struct_to_a rb_struct_to_s
        ).sort
    assert_equal ok, complete('rb_str')
    assert_equal ok, complete('rb__str')
    assert_equal ok, complete('rb', 'str')
    assert_equal ok, complete('_str')
  end

end
