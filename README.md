Tool for generating and decoding JVM bytecode.

Now, this gem supports only minimal part of class file specification.

## Examples

Generating

```rb
require 'jvm_bytecode'

class_file = JvmBytecode::ClassFile.new do
  constant_pool do
    utf8 'Sample'
    utf8 'java/lang/Object'

    add_class 'Sample'

    add_method_ref(
      add_class('java/lang/Object'),
      add_name_and_type('<init>', '()V')
    )
  end

  access_flag :super

  this_class 'Sample'
  super_class 'java/lang/Object'

  method_definition do
    name 'add'
    descriptor '(II)I'

    code do
      max_stack 2
      max_locals 3

      iload_1
      iload_2
      iadd
      ireturn
    end
  end

  method_definition do
    name '<init>'
    descriptor '()V'

    code do
      max_stack 1
      max_locals 1

      aload_0
      invokespecial 8
      _return
    end
  end
end

File.open('Sample.class', 'wb') do |f|
  f.write(class_file.bytecode)
end
```

Decoding

```
irb(main):012:0* require 'jvm_bytecode'
=> true
irb(main):013:0> require 'pp'
=> true
irb(main):014:0> pp JvmBytecode::ClassFile.decode(File.open('Sample.class', 'rb')).to_hash
{:minor_version=>0,
 :major_version=>52,
 :constant_pool=>
  [{:index=>1, :type=>"Utf8", :string=>"Sample"},
   {:index=>2, :type=>"Utf8", :string=>"java/lang/Object"},
   {:index=>3, :type=>"Class", :name_index=>1},
   {:index=>4, :type=>"Class", :name_index=>2},
   {:index=>5, :type=>"Utf8", :string=>"<init>"},
   {:index=>6, :type=>"Utf8", :string=>"()V"},
   {:index=>7, :type=>"NameAndType", :name_index=>5, :descriptor_index=>6},
   {:index=>8, :type=>"MethodRef", :class_index=>4, :name_and_type_index=>7},
   {:index=>9, :type=>"Utf8", :string=>"add"},
   {:index=>10, :type=>"Utf8", :string=>"(II)I"},
   {:index=>11, :type=>"Utf8", :string=>"Code"}],
 :access_flag=>[:super],
 :this_class=>3,
 :super_class=>4,
```
