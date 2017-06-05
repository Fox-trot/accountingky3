﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если НЕ Отчет.РежимРасшифровки Тогда
		ЗаполняемыеНастройки = Новый Структура("Реквизиты, ГруппировкаДоп, ДополнительныеПоля, Показатели",
		                                        Истина, Истина, Истина, Истина);
		ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки);
	КонецЕсли;
		
	УправлениеФормой(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	Отчет.ПредставлениеСпискаОрганизаций = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(СписокСтруктурныхЕдиниц);
	
	Для Каждого ЭлементСписка Из СписокПодразделений Цикл
		Если ЭлементСписка.Значение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка") Тогда 
			ЭлементСписка.Представление = НСтр("ru = 'Головное подразделение'");
		КонецЕсли;				
	КонецЦикла;
	
	Отчет.ПредставлениеСпискаПодразделений = БухгалтерскиеОтчетыКлиентСервер.ВыгрузитьСписокВСтроку(СписокПодразделений);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаОрганизацийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//ДОДЕЛАТЬ	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораСтруктурногоПодразделения", ЭтаФорма, Новый Структура);
	//ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтруктурногоПодразделения",
	//             Новый Структура("Организация, СтруктурноеПодразделение, ДоступноИзменениеОрганизации, РежимРаботы, СписокСтруктурныхЕдиниц, СписокПодразделений, СписокВладельцевГоловныхПодразделений",
	//			                 , , Истина, "ПодборВОтчет", СписокСтруктурныхЕдиниц, СписокПодразделений, СписокВладельцевГоловныхПодразделений), ЭтаФорма, Истина,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаОрганизацийОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не УчетПоВсемОрганизациям Тогда
		СтандартнаяОбработка = Ложь;
	Иначе 
		СписокПодразделений.Очистить();
		СписокСтруктурныхЕдиниц.Очистить();
		СписокВладельцевГоловныхПодразделений.Очистить();
		
		Отчет.ПредставлениеСпискаОрганизаций   = "";
		Отчет.ПредставлениеСпискаПодразделений = "";
		
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодписиПриИзменении(Элемент)

	ВыводитьПодписиРуководителей = Ложь;
	УправлениеФормой(ЭтаФорма);

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодписиРуководителейПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ СТРАНИЦЫ НАСТРОЕК ГРУППИРОВКА

&НаКлиенте
Процедура ПоСубсчетамПриИзменении(Элемент)
	
	Если Не Отчет.ПоСубсчетам и Не Отчет.ПоПодразделам Тогда
		Отчет.ПоПодразделам = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПодразделамПриИзменении(Элемент)
	
	Если Не Отчет.ПоПодразделам и Не Отчет.ПоСубсчетам Тогда
		Отчет.ПоСубсчетам = Истина;
	КонецЕсли;  	
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗабалансовыеСчетаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГРУППИРОВКАДОП

&НаКлиенте
Процедура ГруппировкаДопПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа, "ГруппировкаДоп");  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Поле = "Счет" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ, "ГруппировкаДоп");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущиеДанные.Поле = "Счет" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Поле = "Счет" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя = "ГруппировкаПоСубсчетам" Тогда
		БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ЭтаФорма, "Группировка", Элемент);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Элемент.ТекущиеДанные.Счет = ВыбранноеЗначение;	
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСчетПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамСчетПриИзменении(ЭтаФорма, "Группировка", Элемент);
	Элементы.Группировка.ТекущиеДанные.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ЭтаФорма, "Группировка", Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОчистка(ЭтаФорма, "Группировка", Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ЭтаФорма, "Группировка", Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ РАЗВЕРНУТОЕ САЛЬДО

&НаКлиенте
Процедура РазвернутоеСальдоПриИзменении(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя = "РазвернутоеСальдоПоСубсчетам" Тогда
		БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ЭтаФорма, "РазвернутоеСальдо", Элемент);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоСчетПриИзменении(Элемент)

	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамСчетПриИзменении(ЭтаФорма, "РазвернутоеСальдо", Элемент);
	Элементы.РазвернутоеСальдо.ТекущиеДанные.Использование 	= Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ЭтаФорма, "РазвернутоеСальдо", Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПредставлениеОчистка(Элемент, СтандартнаяОбработка)

	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОчистка(ЭтаФорма, "РазвернутоеСальдо", Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	БухгалтерскиеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ЭтаФорма, "РазвернутоеСальдо", Элемент, ВыбранноеЗначение, СтандартнаяОбработка);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Истина);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДОПОЛНИТЕЛЬНЫЕПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ГруппировкаДоп Цикл
		Если НЕ СтрокаТаблицы.Поле = "Счет" Тогда
			СтрокаТаблицы.Использование = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ГруппировкаДоп Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.РазвернутоеСальдо Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.РазвернутоеСальдо Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ПредставлениеСпискаПодразделений.Видимость = Форма.СписокПодразделений.Количество() > 0;
	
	Элементы.ВыводитьПодписиРуководителей.Доступность = Форма.ВыводитьПодписи;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = СтрШаблон(НСтр("ru = 'Оборотно-сальдовая ведомость %1'"), 
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));

	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Если ЗаполняемыеНастройки.Свойство("Реквизиты") Тогда
		Если ЗаполняемыеНастройки.Реквизиты Тогда
			Отчет.ПоСубсчетам   = Ложь;
			Отчет.ПоПодразделам = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") Тогда
		Если ЗаполняемыеНастройки.Показатели Тогда
			// Управление показателями
			Отчет.ПоказательБУ            = Истина;
			Отчет.ПоказательВалютнаяСумма = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("ДополнительныеПоля") И ЗаполняемыеНастройки.ДополнительныеПоля Тогда

		Отчет.ДополнительныеПоля.Очистить();
		
		НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
		НоваяСтрока.Представление = "Выводить наименование счета";
		НоваяСтрока.Поле          = "Счет.Наименование";
		НоваяСтрока.Использование = Истина;
		
		Если Отчет.РежимРасшифровки Тогда
            Если ЗаполняемыеНастройки.Свойство("ДополнительныеПоляРасшифровки")
                И ЗаполняемыеНастройки.ДополнительныеПоляРасшифровки.Количество() <> 0 Тогда
                ДополнительныеПоляРасшифровки = ЗаполняемыеНастройки.ДополнительныеПоляРасшифровки;
                Для Каждого ДополнительноеПолеРасшифровки Из ДополнительныеПоляРасшифровки Цикл
                    НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
                    НоваяСтрока.Поле 		   = ДополнительноеПолеРасшифровки.Поле;
                    НоваяСтрока.Использование  = Истина;
                    НоваяСтрока.Представление  = ДополнительноеПолеРасшифровки.Представление;
            	КонецЦикла;            
			КонецЕсли;
		
		КонецЕсли;

	КонецЕсли;

	Если ЗаполняемыеНастройки.Свойство("Группировка") И ЗаполняемыеНастройки.Группировка Тогда
		
		// Добавление группировок с соответствии с выбранным счетом	
		Отчет.Группировка.Очистить();

		Если ЗаполняемыеНастройки.Свойство("ГруппировкиРасшифровки")
            И ЗаполняемыеНастройки.ГруппировкиРасшифровки.Количество() <> 0 Тогда
            ГруппировкиРасшифровки = ЗаполняемыеНастройки.ГруппировкиРасшифровки;
			
			Для Каждого ГруппировкаРасшифровки Из ГруппировкиРасшифровки Цикл
                НоваяСтрока = Отчет.Группировка.Добавить();
                НоваяСтрока.Счет 		   = ГруппировкаРасшифровки.Счет;
                НоваяСтрока.Использование  = Истина;
                НоваяСтрока.Представление  = ГруппировкаРасшифровки.Представление;
                НоваяСтрока.ПоСубсчетам    = ГруппировкаРасшифровки.ПоСубсчетам;
                НоваяСтрока.ПоСубконто 	   = ГруппировкаРасшифровки.ПоСубконто;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;

	Если ЗаполняемыеНастройки.Свойство("ГруппировкаДоп") И ЗаполняемыеНастройки.ГруппировкаДоп Тогда
		
		// Добавление группировок с соответствии с выбранным счетом	
		Отчет.ГруппировкаДоп.Очистить();

		НоваяСтрока = Отчет.ГруппировкаДоп.Добавить();
		НоваяСтрока.Поле           = "Счет";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Счет'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия;	
		
		Если ЗаполняемыеНастройки.Свойство("ГруппировкиДопРасшифровки")
            И ЗаполняемыеНастройки.ГруппировкиДопРасшифровки.Количество() <> 0 Тогда
            ГруппировкиДопРасшифровки = ЗаполняемыеНастройки.ГруппировкиДопРасшифровки;
			
			Для Каждого ГруппировкаДопРасшифровки Из ГруппировкиДопРасшифровки Цикл
                НоваяСтрока = Отчет.ГруппировкаДоп.Добавить();
                НоваяСтрока.Поле 		   = ГруппировкаДопРасшифровки.Поле;
                НоваяСтрока.Использование  = Истина;
                НоваяСтрока.Представление  = ГруппировкаДопРасшифровки.Представление;
                НоваяСтрока.ТипГруппировки = ГруппировкаДопРасшифровки.ТипГруппировки;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("РазмещениеДополнительныхПолей") Тогда
		Отчет.РазмещениеДополнительныхПолей = ЗаполняемыеНастройки.РазмещениеДополнительныхПолей;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"                         , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                          , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ПоказательБУ"                          , Отчет.ПоказательБУ);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"               , Отчет.ПоказательВалютнаяСумма);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"         , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("ПоСубсчетам"                           , Отчет.ПоСубсчетам);
	ПараметрыОтчета.Вставить("ПоПодразделам"                         , Отчет.ПоПодразделам);
	ПараметрыОтчета.Вставить("ВыводитьЗабалансовыеСчета"             , Отчет.ВыводитьЗабалансовыеСчета);
	ПараметрыОтчета.Вставить("Группировка"                           , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ГруппировкаДоп"                        , Отчет.ГруппировкаДоп.Выгрузить());
	ПараметрыОтчета.Вставить("РазвернутоеСальдо"                     , Отчет.РазвернутоеСальдо.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"                    , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                      , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("СписокСтруктурныхЕдиниц"               , СписокСтруктурныхЕдиниц);
	ПараметрыОтчета.Вставить("СписокПодразделений"                   , СписокПодразделений);
	ПараметрыОтчета.Вставить("СписокВладельцевГоловныхПодразделений" , СписокВладельцевГоловныхПодразделений);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                     , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодписи"                       , ВыводитьПодписи);
	ПараметрыОтчета.Вставить("ВыводитьПодписиРуководителей"          , ВыводитьПодписиРуководителей);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                     , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                       , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"                 , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"                   , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"             , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                      , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат           = РезультатВыполнения.Результат;	
	ДанныеРасшифровки   = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 

			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда 
		СписокПолей.Добавить("Подразделение");
	КонецЕсли;
	
	Если Режим = "ГруппировкаДоп" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.Элементы Цикл
			Если (Строка(ДоступноеПоле.Поле) <> "Организация") И (Строка(ДоступноеПоле.Поле) <> "Подразделение") И (Строка(ДоступноеПоле.Поле) <> "ВидУчета") Тогда 
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Режим = "Выбор" Тогда
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	ИначеЕсли Режим = "Отбор" ИЛИ Режим = "Порядок" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , Отчет.КонецПериода);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Организация"       , СписокСтруктурныхЕдиниц);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	СписокПараметров.Вставить("ЭтоНовыйДокумент"  , Ложь);
	СписокПараметров.Вставить("ПоддержкаРаботыСоСтруктурнымиПодразделениями", ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(РезультатВыбора, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ПослеВыбораСтруктурногоПодразделения(ЭтаФорма, РезультатВыбора);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры, "ГруппировкаДоп");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДопПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	СписокСтруктурныхЕдиниц.Очистить();
	СписокСтруктурныхЕдиниц.Добавить(Отчет.Организация);
	
	РезультатВыбора = Новый Структура("СписокСтруктурныхЕдиниц", СписокСтруктурныхЕдиниц);
	ДопПараметры = Новый Структура;
	ПослеВыбораСтруктурногоПодразделения(РезультатВыбора, ДопПараметры);
	
КонецПроцедуры  




