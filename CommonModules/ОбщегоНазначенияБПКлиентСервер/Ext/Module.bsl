﻿ ////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции работы с типами

// Служебная функция, предназначенная для получения описания типов числа, заданной разрядности.
// 
// Параметры:
//  Разрядность 			- число, разряд числа.
//  РазрядностьДробнойЧасти - число, разряд дробной части.
//
// Возвращаемое значение:
//  Объект "ОписаниеТипов" для числа указанной разрядности.
//
Функция ПолучитьОписаниеТиповЧисла(Разрядность,РазрядностьДробнойЧасти=0) Экспорт

	Массив = Новый Массив;

	Массив.Добавить(Тип("Число"));
	КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность,РазрядностьДробнойЧасти);

	Возврат Новый ОписаниеТипов(Массив, КвалификаторЧисла);

КонецФункции // ПолучитьОписаниеТиповЧисла() 

// Служебная функция, предназначенная для получения описания типов строки, заданной длины.
//
// Параметры:
//  ДлинаСтроки - число, длина строки.
//
// Возвращаемое значение:
//  Объект "ОписаниеТипов" для строки указанной длины.
//
Функция ПолучитьОписаниеТиповСтроки(ДлинаСтроки) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));

	КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная);

	Возврат Новый ОписаниеТипов(Массив, , КвалификаторСтроки);

КонецФункции // ПолучитьОписаниеТиповСтроки()

// Служебная функция, предназначенная для получения описания типов даты
//
// Параметры:
//  ЧастиДаты - системное перечисление ЧастиДаты.
//
Функция ПолучитьОписаниеТиповДаты(ЧастиДаты) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Дата"));

	КвалификаторДаты = Новый КвалификаторыДаты(ЧастиДаты);

	Возврат Новый ОписаниеТипов(Массив, , , КвалификаторДаты);

КонецФункции // ПолучитьОписаниеТиповДаты()

// Функция возвращает форматированную строку формата 00,00. Дробная часть выводить более мелким шрифтом.
//
// Сумма - Число. Число которое преобразовывается к строке
//
// Возвращает форматированную строку.
//
Функция СуммаФорматированнойСтрокой(Сумма) Экспорт
	
	Сумма = Формат(Сумма, "ЧЦ=15; ЧДЦ=2; ЧН=0,00");
	
	ПозицияРазделителя = СтрНайти(Сумма, ",");
	
	ЦелаяЧастьСуммы = Лев(Сумма, ПозицияРазделителя);
	ДробнаяЧасть	= СтрЗаменить(Сумма, ЦелаяЧастьСуммы, "");
	
	Шрифт14 = Новый Шрифт(,14);
	Шрифт10 = Новый Шрифт(,10);
	
	НадписьЦелаяЧасть = Новый ФорматированнаяСтрока(ЦелаяЧастьСуммы, Шрифт14);
	НадписьДробнаяЧасть = Новый ФорматированнаяСтрока(ДробнаяЧасть, Шрифт10);
	
	А = Новый Массив();
	А.Добавить(НадписьЦелаяЧасть);
	А.Добавить(НадписьДробнаяЧасть);
	
	Возврат Новый ФорматированнаяСтрока(А); 
	
КонецФункции // СуммаФорматированнойСтрокой()

// Дополнительные параметры для указания стратегии изменения параметров учета
// 
// Возвращаемое значение:
//  ДополнительныеПараметры - Структура 
//
Функция ПолучитьСтруктуруДополнительныхПараметров() Экспорт 

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УчетДС", Ложь);
	ДополнительныеПараметры.Вставить("УчетТМЗ", Ложь);
	ДополнительныеПараметры.Вставить("УчетОС", Ложь);
	ДополнительныеПараметры.Вставить("УчетПроизводства", Ложь);

	Возврат ДополнительныеПараметры;

КонецФункции

#Область ПерсонифицированныйУчет

//Функция раскладывает строку с данными о месте рождения на элементы структуры
//
Функция РазложитьМестоРождения(Знач СтрокаМестоРождения, ВерхнийРегистр = Истина) Экспорт
	
	НаселенныйПункт	= "";Район	= "";Область	= "";Страна	= "";
	
	МассивМестоРождения	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(?(ВерхнийРегистр, Врег(СтрокаМестоРождения), СтрокаМестоРождения));
	
	ЭлементовВМассиве = МассивМестоРождения.Количество();   

	Если ЭлементовВМассиве > 0 Тогда
		НаселенныйПункт = СокрЛП(МассивМестоРождения[0]);
	КонецЕсли;
	Если ЭлементовВМассиве > 1 Тогда
		Район = СокрЛП(МассивМестоРождения[1]);
	КонецЕсли;
	Если ЭлементовВМассиве > 2 Тогда
		Область = СокрЛП(МассивМестоРождения[2]);
	КонецЕсли;
	Если ЭлементовВМассиве > 3 Тогда
		Страна = СокрЛП(МассивМестоРождения[3]);
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("НаселенныйПункт",НаселенныйПункт);
	СтруктураВозврата.Вставить("Район",Район);
	СтруктураВозврата.Вставить("Область",Область);
	СтруктураВозврата.Вставить("Страна",Страна);
	Возврат СтруктураВозврата;
	
КонецФункции

//Возвращает строковое представление места рождения
//
Функция ПредставлениеМестаРождения(Знач СтрокаМестоРождения) Экспорт  	
	СтруктураМестоРождения = РазложитьМестоРождения(СтрокаМестоРождения, Ложь);
	
	Представление	= "" + ?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.НаселенныйПункт),		"",	СокрЛП(СтруктураМестоРождения.НаселенныйПункт))
	+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Район),	"",	", " + СокрЛП(СтруктураМестоРождения.Район))
	+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Область),	"",	", "	+	СокрЛП(СтруктураМестоРождения.Область))
	+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Страна),	"",	", "	+	СокрЛП(СтруктураМестоРождения.Страна));
	
	Если Лев(Представление, 1) = ","  Тогда
		Представление = Сред(Представление, 2);
	КонецЕсли;
	
	Возврат СокрЛП(Представление);
КонецФункции	

#КонецОбласти

#Область СпискиВыбора

Процедура Загрузить(ИмяНастройки, СписокВыбора)Экспорт
	
	#Если Клиент Тогда
		ИсторияПоиска = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(ИмяНастройки,);
	#Иначе	
		ИсторияПоиска = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(ИмяНастройки,);
	#КонецЕсли
	
	Если ИсторияПоиска <> Неопределено Тогда
		СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

Процедура Сохранить(ИмяНастройки, СписокВыбора) Экспорт
	
	#Если Клиент Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ИмяНастройки, , СписокВыбора.ВыгрузитьЗначения());
	#Иначе
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ИмяНастройки, , СписокВыбора.ВыгрузитьЗначения());
	#КонецЕсли

КонецПроцедуры // Сохранить()

Процедура ОбновитьСписокВыбора(СписокВыбора, СтрокаПоиска) Экспорт
	
	// Удалим элемент из истории поиска если он там был
	НомерНайденногоЭлементаСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	Пока НомерНайденногоЭлементаСписка <> Неопределено Цикл
		СписокВыбора.Удалить(НомерНайденногоЭлементаСписка);
		НомерНайденногоЭлементаСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	КонецЦикла;
	
	
	// И поставим его на первое место
	СписокВыбора.Вставить(0, СтрокаПоиска);
	Пока СписокВыбора.Количество() > 1000 Цикл
		СписокВыбора.Удалить(СписокВыбора.Количество() - 1);
	КонецЦикла;
	
КонецПроцедуры // ОбновитьСписокВыбора()

Процедура АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	КоличествоНайденных = 0;
	Для каждого ЭлементСписка Из Элемент.СписокВыбора Цикл
		Если ЛЕВ(ВРег(ЭлементСписка.Значение),СтрДлина(СокрЛП(Текст))) = ВРег(СокрЛП(Текст)) Тогда
			ДанныеВыбора.Добавить(ЭлементСписка.Значение);
			КоличествоНайденных = КоличествоНайденных + 1;
			Если КоличествоНайденных > 7 Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // АвтоПодбор()

#КонецОбласти

#Область ПреобразованиеТипов

// Преобразует набор данных с типом СписокЗначений в Массив
// 
Функция СписокЗначенийВМассив(ВхСписокЗначений) Экспорт
	
	МассивДанных = Новый Массив;
	
	Для каждого ЭлементСпискаЗначений Из ВхСписокЗначений Цикл
		
		МассивДанных.Добавить(ЭлементСпискаЗначений.Значение);
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции // СписокЗначенийВМассив()

// Функция опредяет имеет ли тип СписокЗначений полученная переменная
//
Функция ЭтоСписокЗначений(ВходящиеЗначение) Экспорт
	
	Возврат (ТипЗнч(ВходящиеЗначение) = Тип("СписокЗначений"));
	
КонецФункции // ЭтоСписокЗначений()

#КонецОбласти

#Область ФункцилнальныеОпции

// Процедура устанавливает функциональные опции формы документа.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма, в которой требуется установить функциональные опции.
//	Организация - СправочникСсылка.Организации - Ссылка на организацию.
//	Период - Дата - Дата установки периодических опций.
//
Процедура УстановитьПараметрыФункциональныхОпцийФормыДокумента(Форма, Организация, Период = Неопределено) Экспорт
	
	ПараметрыФО = Новый Структура();
	ПараметрыФО.Вставить("Организация", Организация);
	Если Период <> Неопределено Тогда
		ПараметрыФО.Вставить("Период", НачалоМесяца(Период));
		// Приводим к началу месяца для того, чтобы сократить пространство кэшируемых значений.
		// Параметр "Организация" используется в функциональных опциях, привязанных к регистрам сведений с периодичностью Месяц или реже.
	КонецЕсли;
	
	Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

#КонецОбласти

// Копирует элементы из одной коллекции в другую
//
// Параметры:
//	ПриемникЗначения	- коллекция элементов КД, куда копируются параметры
//	ИсточникЗначения	- коллекция элементов КД, откуда копируются параметры
//	ОчищатьПриемник		- признак необходимости очистки приемника (Булево, по умолчанию: истина)
//
Процедура СкопироватьЭлементы(ПриемникЗначения, ИсточникЗначения, ОчищатьПриемник = Истина) Экспорт
	
	Если ТипЗнч(ИсточникЗначения) = Тип("УсловноеОформлениеКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ВариантыПользовательскогоПоляВыборКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ОформляемыеПоляКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ЗначенияПараметровДанныхКомпоновкиДанных") Тогда
		СоздаватьПоТипу = Ложь;
	Иначе
		СоздаватьПоТипу = Истина;
	КонецЕсли;
	ПриемникЭлементов = ПриемникЗначения.Элементы;
	ИсточникЭлементов = ИсточникЗначения.Элементы;
	Если ОчищатьПриемник Тогда
		ПриемникЭлементов.Очистить();
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из ИсточникЭлементов Цикл
		
		Если ТипЗнч(ЭлементИсточник) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
			// Элементы порядка добавляем в начало
			Индекс = ИсточникЭлементов.Индекс(ЭлементИсточник);
			ЭлементПриемник = ПриемникЭлементов.Вставить(Индекс, ТипЗнч(ЭлементИсточник));
		Иначе
			Если СоздаватьПоТипу Тогда
				ЭлементПриемник = ПриемникЭлементов.Добавить(ТипЗнч(ЭлементИсточник));
			Иначе
				ЭлементПриемник = ПриемникЭлементов.Добавить();
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		// В некоторых коллекциях необходимо заполнить другие коллекции
		Если ТипЗнч(ИсточникЭлементов) = Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Поля, ЭлементИсточник.Поля);
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
			ЗаполнитьЭлементы(ЭлементПриемник.Оформление, ЭлементИсточник.Оформление); 
		ИначеЕсли ТипЗнч(ИсточникЭлементов)	= Тип("КоллекцияВариантовПользовательскогоПоляВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
		КонецЕсли;
		
		// В некоторых элементах коллекции необходимо заполнить другие коллекции
		Если ТипЗнч(ЭлементИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Варианты, ЭлементИсточник.Варианты);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			ЭлементПриемник.УстановитьВыражениеДетальныхЗаписей (ЭлементИсточник.ПолучитьВыражениеДетальныхЗаписей());
			ЭлементПриемник.УстановитьВыражениеИтоговыхЗаписей(ЭлементИсточник.ПолучитьВыражениеИтоговыхЗаписей());
			ЭлементПриемник.УстановитьПредставлениеВыраженияДетальныхЗаписей(ЭлементИсточник.ПолучитьПредставлениеВыраженияДетальныхЗаписей ());
			ЭлементПриемник.УстановитьПредставлениеВыраженияИтоговыхЗаписей(ЭлементИсточник.ПолучитьПредставлениеВыраженияИтоговыхЗаписей ());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет одну коллекцию элементов на основании другой
//
// Параметры:
//	ПриемникЗначения	- коллекция элементов КД, куда копируются параметры
//	ИсточникЗначения	- коллекция элементов КД, откуда копируются параметры
//	ПервыйУровень		- уровень структуры коллекции элементов КД для копирования параметров
//
Процедура ЗаполнитьЭлементы(ПриемникЗначения, ИсточникЗначения, ПервыйУровень = Неопределено) Экспорт
	
	Если ТипЗнч(ПриемникЗначения) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		КоллекцияЗначений = ИсточникЗначения;
	Иначе
		КоллекцияЗначений = ИсточникЗначения.Элементы;
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из КоллекцияЗначений Цикл
		Если ПервыйУровень = Неопределено Тогда
			ЭлементПриемник = ПриемникЗначения.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		Иначе
			ЭлементПриемник = ПервыйУровень.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		КонецЕсли;
		Если ЭлементПриемник = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		Если ТипЗнч(ЭлементИсточник) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
			Если ЭлементИсточник.ЗначенияВложенныхПараметров.Количество() <> 0 Тогда
				ЗаполнитьЭлементы(ЭлементПриемник.ЗначенияВложенныхПараметров, ЭлементИсточник.ЗначенияВложенныхПараметров, ПриемникЗначения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Добавляет в коллекцию оформляемых полей компоновки данных новое поле
//
// Параметры:
//	КоллекцияОформляемыхПолей 	- коллекция оформляемых полей КД
//	ИмяПоля						- Строка - имя поля
//
// Возвращаемое значение:
//	ОформляемоеПолеКомпоновкиДанных - созданное поле
//
// Пример:
// 	Форма.УсловноеОформление.Элементы[0].Поля
//
Функция ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля) Экспорт
	
	ПолеЭлемента 		= КоллекцияОформляемыхПолей.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных(ИмяПоля);

	Возврат ПолеЭлемента;
	
КонецФункции

// Добавляет в коллекцию отбора новую группу указанного типа.
//
// Параметры:
//	КоллекцияЭлементовОтбора - КоллекцияЭлементовОтбораКомпоновкиДанных 
//	ТипГруппы - ГруппаЭлементовОтбораКомпоновкиДанных - ГруппаИ или ГруппаИли
//
// Возвращаемое значение:
//	ГруппаЭлементовОтбораКомпоновкиДанных - добавленная группа
//
Функция ДобавитьГруппуОтбора(КоллекцияЭлементовОтбора, ТипГруппы) Экспорт

	ГруппаЭлементовОтбора			 = КоллекцияЭлементовОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.ТипГруппы  = ТипГруппы;
	
	Возврат ГруппаЭлементовОтбора;

КонецФункции

// Устанавливает картинку группе, в которой расположен элемент управления Комментарий.
//
// Параметры:
//  ГруппаДополнительно	 	- ЭлементФормы	 - группа, в которой расположен комментарий.
//  Комментарий  			- Строка - текст комментария.
//
Процедура УстановитьКартинкуДляКомментария(ГруппаДополнительно, Комментарий) Экспорт
	
	ГруппаДополнительно.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Комментарий);
	
КонецПроцедуры

// Устанавливает значение поля организации.
//
// Параметры:
//	ПолеОрганизация - РеквизитФормы - Реквизит формы, в котором нужно установить значение.
//	Организация - СправочникСсылка.Организации - Организация, для которой нужно установить реквизит.
//
Процедура УстановитьЗначениеПолеОрганизация(ПолеОрганизация, Организация) Экспорт
	
	Ключ = СтрЗаменить("_" + Организация.УникальныйИдентификатор(), "-", "");
	ПолеОрганизация = Ключ;
	
КонецПроцедуры

