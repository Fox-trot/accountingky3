﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем АдресРезультата, АдресХранимыхДанных, ИдентификаторЗаданияОбновленияПрогресса, ТекстОшибкиОбновленияДоступа;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НавигационнаяСсылка = "e1cib/app/РегистрСведений.ОбновлениеКлючейДоступаКДанным.Форма.ОбновлениеДоступаНаУровнеЗаписей";
	
	ПериодОбновленияПрогресса = 3;
	АвтообновлениеПрогресса = Не Параметры.ВыключитьАвтообновлениеПрогресса;
	ПоказыватьКоличествоЭлементов = Истина;
	ПоказыватьКоличествоКлючейДоступа = Истина;
	
	ПоказыватьЗадержкуОбработки = Истина;
	ПоляСортировки.Добавить("ЗадержкаОбработкиСписка", "Возр");
	МаксимальнаяДата = УправлениеДоступомСлужебный.МаксимальнаяДата();
	УстановитьКартинкуСортировки(Элементы.СпискиЗадержкаОбработкиСписка, Ложь);
	
	Если Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		Элементы.ГруппаПредупреждениеОграничениеОтключено.Видимость = Истина;
	КонецЕсли;
	
	Если Не УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально(Истина) Тогда
		Элементы.ГруппаПредупреждениеУниверсальноеОграничениеОтключено.Видимость = Истина;
		Элементы.ЗапуститьОбновлениеДоступаСейчас.Доступность = Ложь;
		Элементы.РазрешитьОбновлениеДоступа.Доступность = Ложь;
		Элементы.ВключитьРегламентноеЗадание.Доступность = Ложь;
	КонецЕсли;
	
	Если Параметры.ПоказатьПрогрессПоОтдельнымСпискам Тогда
		Элементы.КраткоПодробно.Показать();
	КонецЕсли;
	
	КоличествоПотоковОбновленияДоступа = Константы.КоличествоПотоковОбновленияДоступа.Получить();
	Если КоличествоПотоковОбновленияДоступа = 0 Тогда
		КоличествоПотоковОбновленияДоступа = 1;
	КонецЕсли;
	Элементы.КоличествоПотоковОбновленияДоступа1.Подсказка =
		Метаданные.Константы.КоличествоПотоковОбновленияДоступа.Подсказка;
	Элементы.КоличествоПотоковОбновленияДоступа2.Подсказка =
		Метаданные.Константы.КоличествоПотоковОбновленияДоступа.Подсказка;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
	 Или ОбщегоНазначения.РазделениеВключено() Тогда
		
		Элементы.ГруппаКоличествоПотоковОбновленияДоступа1.Видимость = Ложь;
		Элементы.ГруппаКоличествоПотоковОбновленияДоступа2.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЗаголовокГруппыКоличествоПотоковОбновленияДоступа();
	
	ПриПовторномОткрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	ОбновитьСостояниеЗаданияОбновленияДоступа();
	ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды();
	
	НачатьОбновлениеПрогресса(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОбновленияПрогресса) Тогда
		ОтменитьОбновлениеПрогрессаНаСервере(ИдентификаторЗаданияОбновленияПрогресса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОбновлениеКлючейДоступаКДанным"
	 Или ИмяСобытия = "Запись_ОбновлениеКлючейДоступаПользователей" Тогда
		
		НачатьОбновлениеПрогресса(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоПотоковОбновленияДоступаПриИзменении(Элемент)
	
	Если КоличествоПотоковОбновленияДоступа = 0 Тогда
		КоличествоПотоковОбновленияДоступа = 1;
	КонецЕсли;
	
	УстановитьКоличествоПотоковОбновленияДоступаНаСервере(КоличествоПотоковОбновленияДоступа);
	
	ОбновитьЗаголовокГруппыКоличествоПотоковОбновленияДоступа();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПотоковОбновленияДоступаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Текст) Тогда
		КоличествоПотоковОбновленияДоступа = Число(Текст);
	Иначе
		КоличествоПотоковОбновленияДоступа = 1;
	КонецЕсли;
	
	КоличествоПотоковОбновленияДоступаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоследнееЗавершениеОбновленияДоступаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьТекстОшибки" Тогда
	#Если МобильныйКлиент Тогда
		ПоказатьПредупреждение(, ТекстОшибкиОбновленияДоступа);
	#Иначе
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ТекстОшибкиОбновленияДоступа);
		ТекстовыйДокумент.Показать(НСтр("ru = 'Ошибка обновления доступа'"));
	#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтообновлениеПрогрессаПриИзменении(Элемент)
	
	НачатьОбновлениеПрогресса();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитыватьПоКоличествуДанныхПриИзменении(Элемент)
	
	ОбновитьВидимостьНастроекОтображения();
	
	ЭтоПовторноеОбновлениеПрогресса = Ложь;
	НачатьОбновлениеПрогресса(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьКоличествоЭлементовПриИзменении(Элемент)
	
	Элементы.СпискиКоличествоЭлементов.Видимость             = ПоказыватьКоличествоЭлементов;
	Элементы.СпискиКоличествоОбработанныхЭлементов.Видимость = ПоказыватьКоличествоЭлементов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьКоличествоКлючейДоступаПриИзменении(Элемент)
	
	Элементы.СпискиКоличествоКлючейДоступа.Видимость             = ПоказыватьКоличествоКлючейДоступа;
	Элементы.СпискиКоличествоОбработанныхКлючейДоступа.Видимость = ПоказыватьКоличествоКлючейДоступа;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗадержкуОбработкиПриИзменении(Элемент)
	
	Элементы.СпискиЗадержкаОбработкиСписка.Видимость = ПоказыватьЗадержкуОбработки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИмяТаблицыПриИзменении(Элемент)
	
	Элементы.СпискиИмяТаблицы.Видимость = ПоказыватьИмяТаблицы;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьОбработанныеСпискиПриИзменении(Элемент)
	
	НачатьОбновлениеПрогресса(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписки

&НаКлиенте
Процедура СпискиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьВидимостьНастроекОтображения", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапуститьОбновлениеДоступаСейчас(Команда)
	
	ПодключитьОбработчикОжидания("ЗапуститьОбновлениеДоступаСейчасОбработчикОжидания", 0.1, Истина);
	Элементы.ЗапуститьОбновлениеДоступаСейчас.Доступность = Ложь;
	ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОбновлениеДоступа(Команда)
	
	ВключитьОбновлениеДоступаНаСервере();
	
	Элементы.ОбновлениеДоступаЗапрещено.Видимость = Ложь;
	Элементы.РегламентноеЗаданиеОтключено.Видимость = Ложь;
	
	НачатьОбновлениеПрогресса(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьИЗапретитьОбновлениеДоступа(Команда)
	
	ПодключитьОбработчикОжидания("ОстановитьИЗапретитьОбновлениеДоступаОбработчикОжидания", 0.1, Истина);
	Элементы.ОстановитьИЗапретитьОбновлениеДоступа.Доступность = Ложь;
	ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПрогресс(Команда)
	
	НачатьОбновлениеПрогресса(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьОбновлениеПрогресса(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОбновленияПрогресса) Тогда
		ОтменитьОбновлениеПрогрессаНаСервере(ИдентификаторЗаданияОбновленияПрогресса);
		Если АвтообновлениеПрогресса Тогда
			АвтообновлениеПрогресса = Ложь;
			Пояснение = НСтр("ru = 'Автообновление прогресса отключено'");
		Иначе
			Пояснение = "";
		КонецЕсли;
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление прогресса отменено'"),,
			Пояснение);
	КонецЕсли;
	
	Элементы.ОбновлениеПрогресса.ТекущаяСтраница = Элементы.ОбновлениеПрогрессаЗавершено;
	Элементы.ОтменитьОбновлениеПрогресса.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РучноеУправление(Команда)
	
	ОткрытьФорму("РегистрСведений.ОбновлениеКлючейДоступаКДанным.Форма.ОбновлениеДоступаРучноеУправление");
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьСписокПоВозрастанию(Команда)
	
	СортироватьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьСписокПоУбыванию(Команда)
	
	СортироватьСписок(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СпискиЗадержкаОбработкиСписка.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Списки.ЗадержкаОбработкиСписка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 999999;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Списки.ОбработаноЭлементов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 100;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Списки.ОбработаноКлючейДоступа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 100;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "--- ---");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьКоличествоПотоковОбновленияДоступаНаСервере(Знач Количество)
	
	Если Константы.КоличествоПотоковОбновленияДоступа.Получить() <> Количество Тогда
		Константы.КоличествоПотоковОбновленияДоступа.Установить(Количество);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокГруппыКоличествоПотоковОбновленияДоступа()
	
	Элементы.ГруппаКоличествоПотоковОбновленияДоступа1.Заголовок =
		Формат(КоличествоПотоковОбновленияДоступа, "ЧГ=") + " "
			+ ПользователиСлужебныйКлиентСервер.ПредметЦелогоЧисла(КоличествоПотоковОбновленияДоступа,
				"", НСтр("ru = 'поток,потока,потоков,,,,,,0'"));
	
	Элементы.ГруппаКоличествоПотоковОбновленияДоступа2.Заголовок =
		Элементы.ГруппаКоличествоПотоковОбновленияДоступа1.Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды()
	
	ОтключитьОбработчикОжидания("ОбновитьСостояниеЗаданияОбновленияДоступаОбработчикОжидания");
	ПодключитьОбработчикОжидания("ОбновитьСостояниеЗаданияОбновленияДоступаОбработчикОжидания", 3.5);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеЗаданияОбновленияДоступаОбработчикОжидания()
	
	ОбновитьСостояниеЗаданияОбновленияДоступа();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеЗаданияОбновленияДоступа(Состояние = Неопределено)
	
	ОбновитьВидимостьНастроекОтображения();
	
	Если Состояние = Неопределено Тогда
		Состояние = СостояниеЗаданияОбновленияДоступа();
	КонецЕсли;
	
	Элементы.ОбновлениеДоступаЗапрещено.Видимость = Состояние.ОбновлениеДоступаЗапрещено;
	Элементы.РегламентноеЗаданиеОтключено.Видимость = Не Состояние.ОбновлениеДоступаЗапрещено
		И РегламентноеЗаданиеОтключено И Не Состояние.ОбновлениеДоступаВыполняется;
	
	ТекстОшибкиОбновленияДоступа = Состояние.ТекстОшибкиОбновленияДоступа;
	
	Если ЗначениеЗаполнено(Состояние.ПоследнееЗавершениеОбновленияДоступа) Тогда
		ФорматЧастей = Новый Соответствие;
		ЖирныйШрифт = Новый Шрифт(Элементы.ПоследнееЗавершениеОбновленияДоступа.Шрифт,,, Истина);
		Если ЗначениеЗаполнено(ТекстОшибкиОбновленияДоступа) Тогда
			Если Состояние.ОбновлениеОтменено Тогда
				Если Состояние.ПоследнееЗавершениеСегодня Тогда
					Шаблон = НСтр("ru = '<1>отменено</1> <2>с ошибкой</2> в %1 через %2'");
				Иначе
					Шаблон = НСтр("ru = '<1>отменено</1> <2>с ошибкой</2> %1 через %2'");
				КонецЕсли;
			Иначе
				Если Состояние.ПоследнееЗавершениеСегодня Тогда
					Шаблон = НСтр("ru = '<1>завершено</1> <2>с ошибкой</2> в %1 через %2'");
				Иначе
					Шаблон = НСтр("ru = '<1>завершено</1> <2>с ошибкой</2> %1 через %2'");
				КонецЕсли;
			КонецЕсли;
			ФорматЧастей.Вставить(1, Новый Структура("Шрифт, ЦветТекста", ЖирныйШрифт, Новый Цвет(255, 0, 0)));
			ФорматЧастей.Вставить(2, Новый Структура("Ссылка", "ПоказатьТекстОшибки"));
		Иначе
			Если Состояние.ОбновлениеОтменено Тогда
				Если Состояние.ПоследнееЗавершениеСегодня Тогда
					Шаблон = НСтр("ru = 'отменено в %1 через %2'")
				Иначе
					Шаблон = НСтр("ru = 'отменено %1 через %2'")
				КонецЕсли;
			Иначе
				Если Состояние.ПоследнееЗавершениеСегодня Тогда
					Шаблон = НСтр("ru = 'завершено в %1 за %2'")
				Иначе
					Шаблон = НСтр("ru = 'завершено %1 за %2'")
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если Состояние.ПоследнееЗавершениеСегодня Тогда
			Шаблон = СтрЗаменить(Шаблон, "%1", "<3>%1</3>");
			ФорматЧастей.Вставить(3, Новый Структура("Шрифт", ЖирныйШрифт));
			
			ПоследнееЗавершение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
				Формат(Состояние.ПоследнееЗавершениеОбновленияДоступа, "ДЛФ=T"),
				Состояние.ПоследнееВыполнениеПродолжительность);
		Иначе
			ПоследнееЗавершение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
				Формат(Состояние.ПоследнееЗавершениеОбновленияДоступа, "ДЛФ=DT"),
				Состояние.ПоследнееВыполнениеПродолжительность);
		КонецЕсли;
		ПоследнееЗавершение = СтрокаСФорматированнымиЧастями("(" + ПоследнееЗавершение + ")", ФорматЧастей, 3);
	Иначе
		ПоследнееЗавершение = "(" + ?(Состояние.ОбновлениеДоступаВыполняется,
			НСтр("ru = 'не завершалось'"), НСтр("ru = 'не запускалось'")) + ")";
	КонецЕсли;
	Элементы.ПоследнееЗавершениеОбновленияДоступа.Заголовок = ПоследнееЗавершение;
	
	ВыполнениеЗаданияЗавершено = ЗначениеЗаполнено(ПоследнееЗавершениеОбновленияДоступа)
		И ЗначениеЗаполнено(Состояние.ПоследнееЗавершениеОбновленияДоступа)
		И ПоследнееЗавершениеОбновленияДоступа <> Состояние.ПоследнееЗавершениеОбновленияДоступа;
	
	ПоследнееЗавершениеОбновленияДоступа = Состояние.ПоследнееЗавершениеОбновленияДоступа;
	
	Элементы.ОбновлениеДоступаВыполняется.Видимость   =    Состояние.ОбновлениеДоступаВыполняется;
	Элементы.ОбновлениеДоступаНеВыполняется.Видимость = Не Состояние.ОбновлениеДоступаВыполняется;
	
	Элементы.ОстановитьИЗапретитьОбновлениеДоступа.Доступность =    Состояние.ОбновлениеДоступаВыполняется;
	Элементы.ЗапуститьОбновлениеДоступаСейчас.Доступность      = Не Состояние.ОбновлениеДоступаВыполняется;
	
	Элементы.КартинкаФоновоеЗаданиеВыполняется.Видимость       =    Состояние.ФоновоеЗаданиеВыполняется;
	Элементы.КартинкаФоновоеЗаданиеОжидаетВыполнения.Видимость = Не Состояние.ФоновоеЗаданиеВыполняется;
	
	Если Не Состояние.ОбновлениеДоступаВыполняется Тогда
		Элементы.ВремяВыполненияФоновогоЗадания1.Заголовок = "";
		Элементы.ВремяВыполненияФоновогоЗадания2.Заголовок = "";
		Если ВыполнениеЗаданияЗавершено И Не АвтообновлениеПрогресса Тогда
			НачатьОбновлениеПрогресса(Истина);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Выполняется %1'"),
		ВремяВыполненияСтрокой(Состояние.ВыполняетсяСекунд));
	
	Элементы.ВремяВыполненияФоновогоЗадания1.Заголовок = ТекстЗаголовка;
	Элементы.ВремяВыполненияФоновогоЗадания2.Заголовок = ТекстЗаголовка;
	
	ВидимостьПервого = Элементы.ВремяВыполненияФоновогоЗадания1.Видимость;
	ВидимостьПервого = Не ВидимостьПервого;
	
	Элементы.ВремяВыполненияФоновогоЗадания1.Видимость =    ВидимостьПервого;
	Элементы.ВремяВыполненияФоновогоЗадания2.Видимость = Не ВидимостьПервого;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВремяВыполненияСтрокой(ВремяВСекундах)
	
	ВсегоМинут = Цел(ВремяВСекундах / 60);
	Секунд = ВремяВСекундах - ВсегоМинут * 60;
	ВсегоЧасов = Цел(ВсегоМинут / 60);
	Минут = ВсегоМинут - ВсегоЧасов * 60;
	
	Если ВсегоЧасов > 0 Тогда
		Шаблон = НСтр("ru = '%3 ч %2 мин %1 сек'");
		
	ИначеЕсли Минут > 0 Тогда
		Шаблон = НСтр("ru = '%2 мин %1 сек'");
	Иначе
		Шаблон = НСтр("ru = '%1 сек'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
		Формат(Секунд, "ЧН=0; ЧГ="), Формат(Минут, "ЧН=0; ЧГ="), Формат(ВсегоЧасов, "ЧГ="));
	
КонецФункции

&НаСервереБезКонтекста
Функция СостояниеЗаданияОбновленияДоступа()
	
	ПоследнееОбновлениеДоступа = УправлениеДоступомСлужебный.ПоследнееОбновлениеДоступа();
	ТекущаяДатаНаСервере = УправлениеДоступомСлужебный.ТекущаяДатаНаСервере();
	
	Состояние = Новый Структура;
	
	Состояние.Вставить("ПоследнееЗавершениеОбновленияДоступа",
		ПоследнееОбновлениеДоступа.ДатаЗавершенияНаСервере);
	
	Состояние.Вставить("ПоследнееВыполнениеПродолжительность",
		ВремяВыполненияСтрокой(ПоследнееОбновлениеДоступа.ПоследнееВыполнениеСекунд));
	
	Состояние.Вставить("ПоследнееЗавершениеСегодня",
		ЭтоСегодняшняяДата(ТекущаяДатаНаСервере, Состояние.ПоследнееЗавершениеОбновленияДоступа));
	
	Состояние.Вставить("ОбновлениеОтменено",
		ПоследнееОбновлениеДоступа.ОбновлениеОтменено);
	
	Состояние.Вставить("ТекстОшибкиОбновленияДоступа",
		ПоследнееОбновлениеДоступа.ТекстОшибкиЗавершения);
	
	Состояние.Вставить("ОбновлениеДоступаЗапрещено",
		ПоследнееОбновлениеДоступа.ОбновлениеДоступаЗапрещено);
	
	Состояние.Вставить("ВыполняетсяСекунд", 0);
	
	Исполнитель = УправлениеДоступомСлужебный.ИсполнительОбновленияДоступа(ПоследнееОбновлениеДоступа);
	
	Если Исполнитель = Неопределено Тогда
		Состояние.Вставить("ОбновлениеДоступаВыполняется", Ложь);
		Состояние.Вставить("ФоновоеЗаданиеВыполняется", Ложь);
		
	ИначеЕсли ТипЗнч(Исполнитель) = Тип("ФоновоеЗадание")
	        И (Исполнитель.УникальныйИдентификатор <> ПоследнееОбновлениеДоступа.ИдентификаторФоновогоЗадания
	           Или ОбщегоНазначения.ИнформационнаяБазаФайловая()
	             И Не СеансФоновогоЗаданияСуществует(Исполнитель)) Тогда
		
		Состояние.Вставить("ОбновлениеДоступаВыполняется", Истина);
		ОжидаетВыполненияСекунд = ТекущаяДатаНаСервере - Исполнитель.Начало;
		ОжидаетВыполненияСекунд = ?(ОжидаетВыполненияСекунд < 0, 0, ОжидаетВыполненияСекунд);
		Состояние.Вставить("ФоновоеЗаданиеВыполняется", ОжидаетВыполненияСекунд < 2);
	Иначе
		Состояние.Вставить("ОбновлениеДоступаВыполняется", Истина);
		Состояние.Вставить("ФоновоеЗаданиеВыполняется", Истина);
		ВыполняетсяСекунд = ТекущаяДатаНаСервере - ПоследнееОбновлениеДоступа.ДатаЗапускаНаСервере;
		Состояние.Вставить("ВыполняетсяСекунд", ?(ВыполняетсяСекунд < 0, 0, ВыполняетсяСекунд));
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

&НаСервереБезКонтекста
Функция СеансФоновогоЗаданияСуществует(ФоновоеЗадание)
	
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	Для Каждого Сеанс Из Сеансы Цикл
		Если Сеанс.ИмяПриложения <> "BackgroundJob" Тогда
			Продолжить;
		КонецЕсли;
		ФоновоеЗаданиеСеанса = Сеанс.ПолучитьФоновоеЗадание();
		Если ФоновоеЗаданиеСеанса = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ФоновоеЗаданиеСеанса.УникальныйИдентификатор = ФоновоеЗадание.УникальныйИдентификатор Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСегодняшняяДата(ТекущаяДата, Дата)
	
	Возврат ТекущаяДата < Дата + 12 * 60 * 6;
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОбновлениеДоступаСейчасОбработчикОжидания()
	
	СостояниеЗаданияОбновленияДоступа = Неопределено;
	
	ТекстПредупреждения = ЗапуститьОбновлениеДоступаСейчасНаСервере(СостояниеЗаданияОбновленияДоступа);
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОбновитьСостояниеЗаданияОбновленияДоступа(СостояниеЗаданияОбновленияДоступа);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьОбновлениеДоступаСейчасНаСервере(СостояниеЗаданияОбновленияДоступа)
	
	Результат = УправлениеДоступомСлужебный.ЗапуститьОбновлениеДоступаНаУровнеЗаписей(Истина);
	
	Если Результат.УжеВыполняется Тогда
		ТекстПредупреждения = Результат.ТекстПредупреждения;
	Иначе
		ТекстПредупреждения = "";
	КонецЕсли;
	
	СостояниеЗаданияОбновленияДоступа = СостояниеЗаданияОбновленияДоступа();
	
	Возврат ТекстПредупреждения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеПрогресса(ЗапускВручную = Ложь)
	
	Если ЗапускВручную И ЗначениеЗаполнено(ИдентификаторЗаданияОбновленияПрогресса) Тогда
		ОтменитьОбновлениеПрогрессаНаСервере(ИдентификаторЗаданияОбновленияПрогресса);
		
	ИначеЕсли Не АвтообновлениеПрогресса И Не ЗапускВручную
	 Или Элементы.ОбновлениеПрогресса.ТекущаяСтраница = Элементы.ОбновлениеПрогрессаВыполняется Тогда
		
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьПрогрессОбработчикОжидания", 0.1, Истина);
	ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды();
	
	Элементы.ОбновлениеПрогресса.ТекущаяСтраница = Элементы.ОбновлениеПрогрессаВыполняется;
	Элементы.ОтменитьОбновлениеПрогресса.Доступность = Ложь;
	Элементы.КартинкаОбновлениеПрогресса.Видимость = Истина;
	Элементы.КартинкаОжиданиеОбновленияПрогресса.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеПрогрессаОбработчикОжидания()
	
	НачатьОбновлениеПрогресса();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПрогрессОбработчикОжидания()
	
	Контекст = Новый Структура;
	Контекст.Вставить("РассчитыватьПоКоличествуДанных",  РассчитыватьПоКоличествуДанных);
	Контекст.Вставить("ПоказыватьОбработанныеСписки",    ПоказыватьОбработанныеСписки И РассчитыватьПоКоличествуДанных);
	Контекст.Вставить("ЭтоПовторноеОбновлениеПрогресса", ЭтоПовторноеОбновлениеПрогресса);
	Контекст.Вставить("ВсегоОбновлено",                  ВсегоОбновлено);
	Контекст.Вставить("ПериодОбновленияПрогресса",       ПериодОбновленияПрогресса);
	Контекст.Вставить("АвтообновлениеПрогресса",         АвтообновлениеПрогресса);
	Контекст.Вставить("ДобавленныеСтроки",               Новый Массив);
	Контекст.Вставить("УдаленныеСтроки",                 Новый Соответствие);
	Контекст.Вставить("ИзмененныеСтроки",                Новый Соответствие);
	
	Попытка
		Статус = НачатьОбновлениеПрогрессаНаСервере(Контекст, АдресРезультата, АдресХранимыхДанных,
			УникальныйИдентификатор, ИдентификаторЗаданияОбновленияПрогресса);
	Исключение
		Элементы.ОтменитьОбновлениеПрогресса.Доступность = Истина;
		ВызватьИсключение;
	КонецПопытки;
	Элементы.ОтменитьОбновлениеПрогресса.Доступность = Истина;
	
	Если Статус = "Выполнено" Тогда
		ОбновитьПрогрессПослеПолученияДанных(Контекст);
		
	ИначеЕсли Статус = "Выполняется" Тогда
		ОбновлениеПрогрессаВыполняется = Ложь;
		ПодключитьОбработчикОжидания("ЗавершитьОбновлениеПрогрессаОбработчикОжидания", 1, Истина);
		ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбновлениеПрогрессаОбработчикОжидания()
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗаданияОбновленияПрогресса) Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Неопределено;
	ЗаданиеВыполнено = ЗавершитьОбновлениеПрогрессаНаСервере(Контекст, АдресРезультата,
		АдресХранимыхДанных, ИдентификаторЗаданияОбновленияПрогресса);
	
	Если Не ЗаданиеВыполнено Тогда
		Если Контекст.ОбновлениеПрогрессаВыполняется Тогда
			ОбновлениеПрогрессаВыполняется = Истина;
		КонецЕсли;
		Элементы.КартинкаОбновлениеПрогресса.Видимость         =    ОбновлениеПрогрессаВыполняется;
		Элементы.КартинкаОжиданиеОбновленияПрогресса.Видимость = Не ОбновлениеПрогрессаВыполняется;
		ПодключитьОбработчикОжидания("ЗавершитьОбновлениеПрогрессаОбработчикОжидания", 1, Истина);
		Возврат;
	КонецЕсли;
	
	ОбновитьПрогрессПослеПолученияДанных(Контекст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПрогрессПослеПолученияДанных(Контекст)
	
	ВсегоОбновлено = Контекст.ВсегоОбновлено;
	Если Контекст.Свойство("ПериодОбновленияПрогресса") Тогда
		ПериодОбновленияПрогресса = Контекст.ПериодОбновленияПрогресса;
	КонецЕсли;
	Если Контекст.Свойство("АвтообновлениеПрогресса") Тогда
		АвтообновлениеПрогресса = Контекст.АвтообновлениеПрогресса;
	КонецЕсли;
	
	РегламентноеЗаданиеОтключено = Контекст.Свойство("РегламентноеЗаданиеОтключено");
	
	ТекущийМомент = ОбщегоНазначенияКлиент.ДатаСеанса();
	ОбновитьЗадержку = ПоляСортировки[0].Значение = "ЗадержкаОбработкиСписка";
	
	Индекс = Списки.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Строка = Списки.Получить(Индекс);
		Если Контекст.УдаленныеСтроки.Получить(Строка.Список) <> Неопределено Тогда
			Списки.Удалить(Индекс);
		Иначе
			ИзмененнаяСтрока = Контекст.ИзмененныеСтроки.Получить(Строка.Список);
			Если ИзмененнаяСтрока <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(Строка, ИзмененнаяСтрока);
			КонецЕсли;
			Если ОбновитьЗадержку Тогда
				ОбновитьЗадержкуОбновленияСписка(Строка, ТекущийМомент);
			КонецЕсли;
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	Для Каждого ДобавленнаяСтрока Из Контекст.ДобавленныеСтроки Цикл
		НоваяСтрока = Списки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДобавленнаяСтрока);
		Если ОбновитьЗадержку Тогда
			ОбновитьЗадержкуОбновленияСписка(НоваяСтрока, ТекущийМомент);
		КонецЕсли;
	КонецЦикла;
	
	Если Контекст.ДобавленныеСтроки.Количество() > 0
	 Или СортировкаСПереходомКНачалу()
	   И Контекст.ИзмененныеСтроки.Количество() > 0  Тогда
		
		СортироватьСписокПоПолям();
	КонецЕсли;
	
	Если АвтообновлениеПрогресса Тогда
		ПодключитьОбработчикОжидания("НачатьОбновлениеПрогрессаОбработчикОжидания",
			ПериодОбновленияПрогресса, Истина);
	КонецЕсли;
	
	Элементы.ОбновлениеПрогресса.ТекущаяСтраница = Элементы.ОбновлениеПрогрессаЗавершено;
	ЭтоПовторноеОбновлениеПрогресса = Истина;
	
	ОбновитьСостояниеЗаданияОбновленияДоступа(Контекст.СостояниеЗаданияОбновленияДоступа);
	ОбновитьСостояниеЗаданияОбновленияДоступаЧерезТриСекунды();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗадержкуОбновленияСписка(Строка, ТекущийМомент)
	
	Делитель = 5;
	
	Если ЗначениеЗаполнено(Строка.ПоследнееОбновление) Тогда
		Строка.ЗадержкаОбработкиСписка =
			Цел((ТекущийМомент - Строка.ПоследнееОбновление) / Делитель) * Делитель;
		
	ИначеЕсли Строка.ПервоеПланированиеОбновления < МаксимальнаяДата Тогда
		Строка.ЗадержкаОбработкиСписка =
			Цел((ТекущийМомент - Строка.ПервоеПланированиеОбновления) / Делитель) * Делитель;
	Иначе
		Строка.ЗадержкаОбработкиСписка = 999999;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НачатьОбновлениеПрогрессаНаСервере(Контекст, АдресРезультата, АдресХранимыхДанных,
			ИдентификаторФормы, ИдентификаторЗаданияОбновленияПрогресса)
	
	Если ЗначениеЗаполнено(АдресХранимыхДанных) Тогда
		ХранимыеДанные = ПолучитьИзВременногоХранилища(АдресХранимыхДанных);
	Иначе
		ХранимыеДанные = Новый Структура;
		ХранимыеДанные.Вставить("СтрокиСписков",    Новый Соответствие);
		ХранимыеДанные.Вставить("СвойстваСписков",  Новый Соответствие);
		ХранимыеДанные.Вставить("КоличествоКлючей", 0);
		ХранимыеДанные.Вставить("ДатаПоследнегоОбновления", '00010101');
		АдресХранимыхДанных = ПоместитьВоВременноеХранилище(ХранимыеДанные, ИдентификаторФормы);
	КонецЕсли;
	
	ФиксированныйКонтекст = Новый ФиксированнаяСтруктура(Контекст);
	ПараметрыПроцедуры = Новый Структура(ФиксированныйКонтекст);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
	ПараметрыПроцедуры.Вставить("ХранимыеДанные", ХранимыеДанные);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.АдресРезультата = АдресРезультата;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Управление доступом: Получение прогресса обновления доступа'");
	
	РезультатЗапуска = ДлительныеОперации.ВыполнитьВФоне("УправлениеДоступомСлужебный.ОбновитьПрогрессВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
	ИдентификаторЗаданияОбновленияПрогресса = Неопределено;
	
	Если РезультатЗапуска.Статус = "Выполнено" Тогда
		ЗавершитьОбновлениеПрогрессаНаСервере(Контекст, АдресРезультата,
			АдресХранимыхДанных, Неопределено);
		
	ИначеЕсли РезультатЗапуска.Статус = "Выполняется" Тогда
		ИдентификаторЗаданияОбновленияПрогресса = РезультатЗапуска.ИдентификаторЗадания;
		
	ИначеЕсли РезультатЗапуска.Статус = "Ошибка" Тогда
		ВызватьИсключение РезультатЗапуска.ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	Возврат РезультатЗапуска.Статус;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьОбновлениеПрогрессаНаСервере(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ИдентификаторЗадания = Неопределено;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗавершитьОбновлениеПрогрессаНаСервере(Контекст, Знач АдресРезультата, Знач АдресХранимыхДанных,
			ИдентификаторЗаданияОбновленияПрогресса)
	
	Если ИдентификаторЗаданияОбновленияПрогресса <> Неопределено
	   И Не ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗаданияОбновленияПрогресса) Тогда
		
		Контекст = Новый Структура("ОбновлениеПрогрессаВыполняется",
			ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗаданияОбновленияПрогресса) <> Неопределено);
		Возврат Ложь;
	КонецЕсли;
	ИдентификаторЗаданияОбновленияПрогресса = Неопределено;
	
	Контекст = ПолучитьИзВременногоХранилища(АдресРезультата);
	ПоместитьВоВременноеХранилище(Контекст.ХранимыеДанные, АдресХранимыхДанных);
	Контекст.Удалить("ХранимыеДанные");
	
	Контекст.Вставить("СостояниеЗаданияОбновленияДоступа", СостояниеЗаданияОбновленияДоступа());
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьВидимостьНастроекОтображения()
	
	ОтображатьНастройки = РассчитыватьПоКоличествуДанных
		И Не Элементы.КраткоПодробно.Скрыта();
	
	Если Элементы.НастройкиОтображения.Видимость <> ОтображатьНастройки Тогда
		Элементы.НастройкиОтображения.Видимость = ОтображатьНастройки;
		
		Если ОтображатьНастройки Тогда
			Элементы.СпискиКоличествоЭлементов.Видимость                 = ПоказыватьКоличествоЭлементов;
			Элементы.СпискиКоличествоОбработанныхЭлементов.Видимость     = ПоказыватьКоличествоЭлементов;
			Элементы.СпискиКоличествоКлючейДоступа.Видимость             = ПоказыватьКоличествоКлючейДоступа;
			Элементы.СпискиКоличествоОбработанныхКлючейДоступа.Видимость = ПоказыватьКоличествоКлючейДоступа;
			Элементы.СпискиИмяТаблицы.Видимость                          = ПоказыватьИмяТаблицы;
		Иначе
			Элементы.СпискиКоличествоЭлементов.Видимость                 = Ложь;
			Элементы.СпискиКоличествоОбработанныхЭлементов.Видимость     = Ложь;
			Элементы.СпискиКоличествоКлючейДоступа.Видимость             = Ложь;
			Элементы.СпискиКоличествоОбработанныхКлючейДоступа.Видимость = Ложь;
			Элементы.СпискиИмяТаблицы.Видимость                          = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СпискиЗадержкаОбработкиСписка.Видимость = ПоказыватьЗадержкуОбработки;
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьСписок(ПоУбыванию = Ложь)
	
	ТекущаяКолонка = Элементы.Списки.ТекущийЭлемент;
	
	Если ТекущаяКолонка = Неопределено
	 Или Не СтрНачинаетсяС(ТекущаяКолонка.Имя, "Списки") Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выберите колонку для сортировки'"));
		Возврат;
	КонецЕсли;
	
	ОчиститьКартинкуСортировки(Элементы["Списки" + ПоляСортировки[0].Значение]);
	
	ПоляСортировки.Очистить();
	
	Поле = Сред(ТекущаяКолонка.Имя, СтрДлина("Списки") + 1);
	ПоляСортировки.Добавить(Поле, ?(ПоУбыванию, "Убыв", "Возр"));
	Если Поле <> "СписокПредставление" Тогда
		ПоляСортировки.Добавить("СписокПредставление", "Возр");
	КонецЕсли;
	
	УстановитьКартинкуСортировки(ТекущаяКолонка, ПоУбыванию);
	
	СортироватьСписокПоПолям();
	
	ПоказатьОповещениеПользователя(
		?(ПоУбыванию, НСтр("ru = 'Сортировка по убыванию'"),
			НСтр("ru = 'Сортировка по возрастанию'")),,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Колонка ""%1""'"),
			СтрЗаменить(ТекущаяКолонка.Заголовок, Символы.ПС, " ")));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКартинкуСортировки(Элемент, ПоУбыванию)
	
	ДобавкаШирины = 3;
	
	Если Элемент.Ширина > 0 Тогда
		Элемент.Ширина = Элемент.Ширина + ДобавкаШирины;
	КонецЕсли;
	Элемент.КартинкаШапки = ?(ПоУбыванию,
		БиблиотекаКартинок.СортироватьСписокПоУбыванию,
		БиблиотекаКартинок.СортироватьСписокПоВозрастанию);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьКартинкуСортировки(Элемент)
	
	ДобавкаШирины = 3;
	
	Элемент.КартинкаШапки = Новый Картинка;
	Если Элемент.Ширина > ДобавкаШирины Тогда
		Элемент.Ширина = Элемент.Ширина - ДобавкаШирины;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СортировкаСПереходомКНачалу()
	
	Возврат ПоляСортировки[0].Значение <> "СписокПредставление";
	
КонецФункции

&НаКлиенте
Процедура СортироватьСписокПоПолям(ИндексПоляСортировки = 0, СтрокиСписка = Неопределено)
	
	Если ИндексПоляСортировки >= ПоляСортировки.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ПолеСортировки = ПоляСортировки[ИндексПоляСортировки].Значение;
	Если СтрокиСписка = Неопределено Тогда
		СтрокиСписка = Новый СписокЗначений;
		Если Списки.Количество() < 2 Тогда
			Возврат;
		КонецЕсли;
		Для Каждого Строка Из Списки Цикл
			СтрокиСписка.Добавить(Строка,
				ПредставлениеДляСортировки(Строка[ПолеСортировки]));
		КонецЦикла;
	ИначеЕсли СтрокиСписка.Количество() < 2 Тогда
		Возврат;
	Иначе
		Для Каждого ЭлементСписка Из СтрокиСписка Цикл
			ЭлементСписка.Представление =
				ПредставлениеДляСортировки(ЭлементСписка.Значение[ПолеСортировки]);
		КонецЦикла;
	КонецЕсли;
	
	НачальныйИндекс = Списки.Индекс(СтрокиСписка[0].Значение);
	СтрокиСписка.СортироватьПоПредставлению(
		НаправлениеСортировки[ПоляСортировки[ИндексПоляСортировки].Представление]);
	
	ТекущееПредставление = Неопределено;
	Подстроки = Неопределено;
	НовыйИндекс = НачальныйИндекс;
	Для Каждого ЭлементСписка Из СтрокиСписка Цикл
		ТекущийИндекс = Списки.Индекс(ЭлементСписка.Значение);
		Если ТекущийИндекс <> НовыйИндекс Тогда
			Списки.Сдвинуть(ТекущийИндекс, НовыйИндекс - ТекущийИндекс);
		КонецЕсли;
		Если ТекущееПредставление <> ЭлементСписка.Представление Тогда
			Если Подстроки <> Неопределено Тогда
				СортироватьСписокПоПолям(ИндексПоляСортировки + 1, Подстроки);
			КонецЕсли;
			Подстроки = Новый СписокЗначений;
			ТекущееПредставление = ЭлементСписка.Представление;
		КонецЕсли;
		Подстроки.Добавить(ЭлементСписка.Значение);
		НовыйИндекс = НовыйИндекс + 1;
	КонецЦикла;
	
	Если Подстроки <> Неопределено Тогда
		СортироватьСписокПоПолям(ИндексПоляСортировки + 1, Подстроки);
	КонецЕсли;
	
	Если ИндексПоляСортировки = 0
	   И СортировкаСПереходомКНачалу()
	   И Списки.Количество() > 0 Тогда
		
		Элементы.Списки.ТекущаяСтрока = Списки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПредставлениеДляСортировки(Значение)
	
	Возврат Формат(Значение, "ЧЦ=15; ЧДЦ=4; ЧН=00000000000,0000; ЧВН=; ЧГ=");
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВключитьОбновлениеДоступаНаСервере()
	
	УправлениеДоступомСлужебный.УстановитьЗапретОбновленияДоступа(Ложь);
	УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьИЗапретитьОбновлениеДоступаОбработчикОжидания()
	
	ОстановитьИЗапретитьОбновлениеДоступаНаСервере();
	
	Элементы.ОбновлениеДоступаЗапрещено.Видимость = Истина;
	Элементы.РегламентноеЗаданиеОтключено.Видимость = Ложь;
	
	НачатьОбновлениеПрогресса(Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОстановитьИЗапретитьОбновлениеДоступаНаСервере()
	
	УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Ложь);
	УправлениеДоступомСлужебный.ОтменитьОбновлениеДоступаНаУровнеЗаписей();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаСФорматированнымиЧастями(Шаблон, ФорматЧастей, КоличествоФорматируемыхЧастей)
	
	Части = Новый Массив;
	
	Для НомерФорматируемойЧасти = 1 По КоличествоФорматируемыхЧастей Цикл
		РазделительНачало = "<"  + НомерФорматируемойЧасти + ">";
		РазделительКонец  = "</" + НомерФорматируемойЧасти + ">";
		Если СтрЧислоВхождений(Шаблон, РазделительНачало) <> 1
		 Или СтрЧислоВхождений(Шаблон, РазделительКонец) <> 1 Тогда
			Шаблон = СтрЗаменить(Шаблон, РазделительНачало, "");
			Шаблон = СтрЗаменить(Шаблон, РазделительКонец, "");
			Продолжить;
		КонецЕсли;
	Позиция = СтрНайти(Шаблон, РазделительНачало);
		Если Позиция > 1 Тогда
			Строка = Лев(Шаблон, Позиция - 1);
			Части.Добавить(СтрокаСФорматированнымиЧастями(Строка, ФорматЧастей, КоличествоФорматируемыхЧастей));
		КонецЕсли;
		Шаблон = Сред(Шаблон, Позиция + СтрДлина(РазделительНачало));
		Позиция = СтрНайти(Шаблон, РазделительКонец);
		ФорматируемаяСтрока = Лев(Шаблон, Позиция - 1);
		Если ФорматЧастей.Получить(НомерФорматируемойЧасти) <> Неопределено Тогда
			ПараметрыФормата = Новый Структура("Шрифт, ЦветТекста, ЦветФона, Ссылка");
			ЗаполнитьЗначенияСвойств(ПараметрыФормата, ФорматЧастей.Получить(НомерФорматируемойЧасти));
			ФорматируемаяСтрока = Новый ФорматированнаяСтрока(ФорматируемаяСтрока,
				ПараметрыФормата.Шрифт, ПараметрыФормата.ЦветТекста, ПараметрыФормата.ЦветФона, ПараметрыФормата.Ссылка);
		КонецЕсли;
		Части.Добавить(ФорматируемаяСтрока);
		Шаблон = Сред(Шаблон, Позиция + СтрДлина(РазделительКонец));
		Если Шаблон = "" Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Шаблон <> "" Тогда
		Части.Добавить(Шаблон);
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(Части);
	
КонецФункции

#КонецОбласти
