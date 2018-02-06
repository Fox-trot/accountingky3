﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем СведенияОДокументе;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Обработки.ПодборСотрудника.ПроверитьЗаполнениеПараметров(Параметры, Отказ);
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьДанныеОбъекта();
	ЗаполнитьСведенияОДокументе(СведенияОДокументе);
	
	ИзменитьТекстЗапросаСписок();
	
	ПодключитьПолнотекстовыйПоискПриОткрытииПодбора();
	УстановитьПараметрыДинамическихСписков();
	
	КешНастройкиПодбора = Новый Структура;
	КешНастройкиПодбора.Вставить("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	КешНастройкиПодбора.Вставить("СведенияОДокументе", СведенияОДокументе);
	КешНастройкиПодбора.Вставить("ПоискВыполненПриОкончанииРедактирования", Ложь);
	
	КешНастройкиПодбора.Вставить("ТекущийВидОтбора", "ОтборПоГруппам");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, КешНастройкиПодбора.ТекущийВидОтбора, "Пометка", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подразделение", "Видимость", НЕ Объект.Подразделение.Пустая());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтборПоПодразделениям", "Видимость", Объект.Подразделение.Пустая());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархия", "Видимость", КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппам");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияПоПодразделениям", "Видимость", КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоПодразделениям");
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭтаФорма.СписокИерархияПоПодразделениям.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		Объект.Организация,
		,
		,
		Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события ПриАктивизацииСтроки реквизита СписокИерархия
//
Процедура СписокИерархияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьОтборПоГруппеДинамическихСписков", 0.2, Истина);
	
КонецПроцедуры // СписокИерархияПриАктивизацииСтроки()

&НаКлиенте
// Процедура - обработчик события ПриАктивизацииСтроки реквизита СписокИерархия
//
Процедура СписокИерархияПоПодразделениямПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьОтборПоГруппеДинамическихСписков", 0.2, Истина);
	
КонецПроцедуры // СписокИерархияСписокИерархияПоПодразделениямПриАктивизацииСтроки()

&НаКлиенте
// Процедура - обработчик события Выбор реквизита СписокЗапасы
//
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьВКорзину();
	
КонецПроцедуры // СписокЗапасыВыбор()

&НаКлиенте
// Процедура - обработчик события ОкончаниеПеретаскивания реквизита СписокЗапасы
//
Процедура СписокОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьВКорзину();
	
КонецПроцедуры // СписокЗапасыОкончаниеПеретаскивания()

&НаКлиенте
// Процедура - обработчик события ПриИзменении реквизита ТекстПоиска
//
Процедура ТекстПоискаПриИзменении(Элемент)
	
	Если ПустаяСтрока(ТекстПоиска) Тогда
		Если ИспользоватьПолнотекстовыйПоиск Тогда
			РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Ссылка");
		Иначе
			КонтекстныйПоискНаКлиенте();
		КонецЕсли;
	Иначе
		ВыполнитьПоискИУстановитьОтбор();
		КешНастройкиПодбора.ПоискВыполненПриОкончанииРедактирования = Истина;
	КонецЕсли;
	
КонецПроцедуры // ТекстПоискаПриИзменении()

&НаКлиенте
// Процедура - обработчик события Очистка реквизита ТекстПоиска
//
Процедура ТекстПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекстПоиска = "";
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Ссылка");
	Иначе
		КонтекстныйПоискНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ТекстПоискаОчистка()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик команды ВыполнитьПоиск
//
Процедура ВыполнитьПоиск(Команда)
	
	Если НЕ КешНастройкиПодбора.ПоискВыполненПриОкончанииРедактирования Тогда
		ВыполнитьПоискИУстановитьОтбор();
	Иначе
		КешНастройкиПодбора.ПоискВыполненПриОкончанииРедактирования = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьПоиск()

&НаКлиенте
// Процедура - обработчик команды ПеренестиВДокумент
//
Процедура ПеренестиВДокумент(Команда)
	
	Закрыть(ЗаписатьПодборВХранилище());
	
КонецПроцедуры // ПеренестиВДокумент()

// Процедура - обработчик команды Выбрать
//
&НаКлиенте
Процедура ДобавитьСтрокуВКорзину(Команда)
	
	ДобавитьВКорзину();
	
КонецПроцедуры // ДобавитьСтрокуВКорзину()

&НаКлиенте
//Процедура - обработчик команды ПерейтиКРодителю (контекст. меню списка)
//
Процедура ПерейтиКРодителю(Команда)
	
	ДанныеТекущейСтроки = ПолучитьДанныеТекущейСтрокиСписка();
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		Элементы.СписокИерархия.ТекущаяСтрока = ДанныеТекущейСтроки.Родитель;
	КонецЕсли;
	
КонецПроцедуры // ПерейтиКРодителю()

&НаКлиенте
//Процедура - обработчик команды ИзменитьВидимостьКорзины (меню формы)
//
Процедура ИзменитьВидимостьКорзины(Команда)
	
	Элементы.ФормаИзменитьВидимостьКорзины.Пометка = НЕ Элементы.ФормаИзменитьВидимостьКорзины.Пометка;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КорзинаЦенаОстатокРезервХарактеристика", "Видимость", Элементы.ФормаИзменитьВидимостьКорзины.Пометка);
	
КонецПроцедуры // ИзменитьВидимостьКорзины()

&НаКлиенте
//Процедура - обработчик команды ПереходПолнотектовыйПоиск
Процедура ПереходПолнотектовыйПоиск(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.ТекстПоиска);
	
КонецПроцедуры // ПереходПолнотектовыйПоиск()

&НаКлиенте
//Процедура - обработчик команды ПереходИерархия
Процедура ПереходИерархия(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.СписокИерархия);
	
КонецПроцедуры // ПереходИерархия()

&НаКлиенте
//Процедура - обработчик команды ПереходКорзина
Процедура ПереходКорзина(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.Корзина);
	
КонецПроцедуры // ПереходКорзина()

&НаКлиенте
//Процедура - обработчик команды СведенияОДокументе
//
Процедура СведенияОДокументе(Команда)
	
	ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПослеЗакрытияФормыСведенияОДокументе", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПодборСотрудника.Форма.СведенияОДокументе", 
		КешНастройкиПодбора.СведенияОДокументе, ЭтаФорма, Истина, , ,ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // СведенияОДокументе()

&НаКлиенте
// Процедура - обработчик команды ОтборПоГруппам
//
Процедура ОтборПоГруппам(Команда)
	
	ПереключитьВидОтбора(Команда.Действие);
	
КонецПроцедуры // ОтборПоГруппам()

&НаКлиенте
// Процедура - обработчик команды ОтборПоПодразделениям
//
Процедура ОтборПоПодразделениям(Команда)
	
	ПереключитьВидОтбора(Команда.Действие);
	
КонецПроцедуры // ОтборПоПодразделениям()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолнотекстовыйПоиск

&НаСервереБезКонтекста
// Функция заполняет массив ссылок результата поиска или возвращает описание ошибки
//
//
Функция ПолнотекстовыйПоискНаСервереБезКонтекста(СтрокаПоиска, РезультатПоиска)
	
	ОписаниеОшибки = "";
	РезультатПоиска = Поиск(СтрокаПоиска, ОписаниеОшибки);
	
	Возврат ОписаниеОшибки;
	
КонецФункции // ПолнотекстовыйПоискНаСервереБезКонтекста()

&НаСервереБезКонтекста
Функция ПолнотекстовыйПоискПозиции(СтрокаПоиска, РезультатПоиска)
	
	// Поиск данных
	РазмерПорции = 200;
	ОбластьПоиска = Новый Массив;
	ОбластьПоиска.Добавить(Метаданные.Справочники.ФизическиеЛица);
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	СписокПоиска.ПолучатьОписание = Ложь;
	СписокПоиска.ОбластьПоиска = ОбластьПоиска;
	СписокПоиска.ПерваяЧасть();
	
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда
		Возврат "СлишкомМногоРезультатов";
	КонецЕсли;
	
	КоличествоНайденныхЭлементов = СписокПоиска.ПолноеКоличество();
	Если КоличествоНайденныхЭлементов = 0 Тогда
		Возврат "НичегоНеНайдено";
	КонецЕсли;
	
	// Обработка данных
	НачальнаяПозиция	= 0;
	КонечнаяПозиция		= ?(КоличествоНайденныхЭлементов > РазмерПорции, РазмерПорции, КоличествоНайденныхЭлементов) - 1;
	ЕстьСледующаяПорция = Истина;

	Пока ЕстьСледующаяПорция Цикл
		
		Для СчетчикЭлементов = 0 По КонечнаяПозиция Цикл
			
			Элемент = СписокПоиска.Получить(СчетчикЭлементов);
			
			Если Элемент.Метаданные = Метаданные.Справочники.ФизическиеЛица Тогда
				РезультатПоиска.Позиции.Добавить(Элемент.Значение);
			Иначе
				ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
			КонецЕсли;
			
		КонецЦикла;
		
		НачальнаяПозиция    = НачальнаяПозиция + РазмерПорции;
		ЕстьСледующаяПорция = (НачальнаяПозиция < КоличествоНайденныхЭлементов - 1);
		
		Если ЕстьСледующаяПорция Тогда
			
			КонечнаяПозиция = ?(КоличествоНайденныхЭлементов > НачальнаяПозиция + РазмерПорции,
			                    РазмерПорции, КоличествоНайденныхЭлементов - НачальнаяПозиция) - 1;
			СписокПоиска.СледующаяЧасть();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "ВыполненоУспешно";
	
КонецФункции

&НаСервереБезКонтекста
Функция Поиск(СтрокаПоиска, ОписаниеОшибки) Экспорт
	
	РезультатПоиска = Новый Структура;
	РезультатПоиска.Вставить("Позиции", Новый Массив);
	
	Результат = ПолнотекстовыйПоискПозиции(СтрокаПоиска, РезультатПоиска);
	
	Если Результат = "ВыполненоУспешно" Тогда
		
		Возврат РезультатПоиска;
		
	ИначеЕсли Результат = "СлишкомМногоРезультатов" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Слишком много результатов. Уточните запрос.'");
		Возврат РезультатПоиска;
		
	ИначеЕсли Результат = "НичегоНеНайдено" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Ничего не найдено'");
		Возврат РезультатПоиска;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
// Процедура устанавливает отбор по ссылкам полученными полнотекстовым поиском
//
Процедура ПолнотекстовыйПоискНаКлиенте()
	
	Если НЕ ПустаяСтрока(ТекстПоиска) Тогда
		
		РезультатПоиска = Неопределено;
		ОписаниеОшибки = ПолнотекстовыйПоискНаСервереБезКонтекста(ТекстПоиска, РезультатПоиска);
		
		Если ПустаяСтрока(ОписаниеОшибки) Тогда
			Использование = РезультатПоиска.Позиции.Количество() > 0;
			МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "Ссылка");
			Если МассивЭлементов.Количество() = 0 Тогда
				
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
					"Ссылка", ВидСравненияКомпоновкиДанных.ВСписке, РезультатПоиска.Позиции, , Использование);
			Иначе
				ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
					"Ссылка", , РезультатПоиска.Позиции, ВидСравненияКомпоновкиДанных.ВСписке, Использование);
			КонецЕсли;
			
			ЭтаФорма.ТекущийЭлемент = Элементы.Список;
		Иначе
			ПоказатьПредупреждение(Неопределено, ОписаниеОшибки, 5, "Поиск...");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПолнотекстовыйПоискНаКлиенте()

&НаКлиенте
// Процедура устанавливает отбор по ссылкам полученными контектным поиском
//
Процедура КонтекстныйПоискНаКлиенте()
	
	ПредставлениеГруппыПолей = "Контекстный поиск";
	
	Если ПустаяСтрока(ТекстПоиска) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка", ПредставлениеГруппыПолей);
		
	Иначе
		
		МассивОтборов = СформироватьМассивОтбораПоПозиции(ТекстПоиска);
		
		МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, , ПредставлениеГруппыПолей);
		Если МассивЭлементов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
				"Ссылка", ВидСравненияКомпоновкиДанных.Равно, МассивОтборов, ПредставлениеГруппыПолей, Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
				"Ссылка", ПредставлениеГруппыПолей, МассивОтборов, ВидСравненияКомпоновкиДанных.Равно, Истина);
		КонецЕсли;
		
		ЭтаФорма.ТекущийЭлемент = Элементы.Список;
	КонецЕсли;
	
КонецПроцедуры // КонтекстныйПоискНаКлиенте()

&НаСервереБезКонтекста
Функция СформироватьМассивОтбораПоПозиции(ТекстПоиска)
	
	ТекстЗапроса = 
		"Выбрать СпрПозиции.Ссылка КАК Ссылка
		|Поместить ПозицииПоНаименование Из Справочник.ФизическиеЛица КАК СпрПозиции
		|Где СпрПозиции.Наименование ПОДОБНО &ТекстПоиска;
		|////////////////////////////////////////////////////////////////////////////
		|Выбрать СпрПозиции.Ссылка КАК Ссылка
		|Поместить ПозицииПоФИО Из Справочник.ФизическиеЛица КАК СпрПозиции
		|Где СпрПозиции.ФИО ПОДОБНО &ТекстПоиска;
		|////////////////////////////////////////////////////////////////////////////
		|Выбрать СпрПозиции.Ссылка КАК Ссылка
		|Поместить ПозицииПоКоду Из Справочник.ФизическиеЛица КАК СпрПозиции
		|Где СпрПозиции.Код ПОДОБНО &ТекстПоиска;
		|////////////////////////////////////////////////////////////////////////////
		|Выбрать ПозицииПоНаименование.Ссылка КАК Ссылка
		|Объединить
		|Выбрать ПозицииПоФИО.Ссылка
		|Объединить
		|Выбрать ПозицииПоКоду.Ссылка";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекстПоиска", "%" + ТекстПоиска + "%");
	ВременнаяТаблицаНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Возврат ВременнаяТаблицаНоменклатуры.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
// Процедура инициализирует выполнение полнотекстового поиска и установку отбора
// 
Процедура ВыполнитьПоискИУстановитьОтбор()
	
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		ПолнотекстовыйПоискНаКлиенте();
	Иначе
		КонтекстныйПоискНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьПоискИУстановитьОтбор()

&НаСервере
// Процедура устанавливает подсказку ввода для элемента формы ПоискТекста
//
Процедура УстановитьПодсказкуВводаСтрокиПоискаНаСервере()
	
	ПолнотекстовыйПоискНастроенЧастично = (ИспользоватьПолнотекстовыйПоиск И НЕ АктуальностьИндексаППД);
	ПодсказкаВвода = ?(ПолнотекстовыйПоискНастроенЧастично, НСтр("ru = 'Необходимо обновить индекс полнотекстового поиска...'"), НСтр("ru = '(ALT+F3) Введите текст поиска...'"));
	Элементы.ТекстПоиска.ПодсказкаВвода = ПодсказкаВвода;
	
КонецПроцедуры // УстановитьПодсказкуВводаСтрокиПоискаНаСервере()

&НаСервере
// Процедура подключает полнотекстовый поиск и устанавливает свойства реквизитов формы
//
Процедура ПодключитьПолнотекстовыйПоискПриОткрытииПодбора()
	
	ИспользоватьПолнотекстовыйПоиск = ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск");
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		
		АктуальностьИндексаППД = ПолнотекстовыйПоиск.ИндексАктуален();
		
		Если НЕ АктуальностьИндексаППД Тогда
			
			Если ОбщегоНазначения.РазделениеВключено()
				И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				
				//в разделенной ИБ считаем актуальным индекс в пределах 2 дней
				АктуальностьИндексаППД = ПолнотекстовыйПоиск.ДатаАктуальности() >= (ТекущаяДатаСеанса()-(2*24*60*60));
				
			Иначе
				
				//в неразделенной ИБ считаем актуальным индекс в пределах дня
				АктуальностьИндексаППД = ПолнотекстовыйПоиск.ДатаАктуальности() >= (ТекущаяДатаСеанса() - (1*24*60*60));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПодсказкуВводаСтрокиПоискаНаСервере();
	
КонецПроцедуры // ПодключитьПолнотекстовыйПоискПриОткрытииПодбора()

#КонецОбласти

#Область ДобавлениеВКорзину

&НаКлиенте
// Функция ищет строки в корзине подбора с указанной позицией
// 	используется перед добавление в корзину.
//
// Возвращает:
//		- Неопределено, если позиция не найдена;
//		- Строку корзины, если позиция найдена;
//
Функция НайтиВКорзине(ДанныеТекущейСтроки)
	
	СтруктураОтбора = Новый Структура("ФизЛицо", ДанныеТекущейСтроки.Ссылка);
	НайденныеСтроки = Объект.Корзина.НайтиСтроки(СтруктураОтбора);
	
	Возврат ?(НайденныеСтроки.Количество() = 0, Неопределено, НайденныеСтроки[0]);
	
КонецФункции // НайтиВКорзине()

&НаКлиенте
// Процедура добавления позиции в корзину подбора
//
Процедура ДобавитьВКорзину()
	
	ДанныеТекущейСтроки = ПолучитьДанныеТекущейСтрокиСписка();
	Если ДанныеТекущейСтроки = Неопределено
		Или ДанныеТекущейСтроки.Подобран Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайтиВКорзине(ДанныеТекущейСтроки);
	
	Если НайденнаяСтрока = Неопределено Тогда
		СтрокаКорзины = Объект.Корзина.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКорзины, ДанныеТекущейСтроки);
		СтрокаКорзины.ФизЛицо = ДанныеТекущейСтроки.Ссылка;
	Иначе
		СтрокаКорзины = НайденнаяСтрока;
	КонецЕсли;
КонецПроцедуры // ДобавитьВКорзину()

#КонецОбласти

#Область УправлениеСписками

&НаКлиенте
// Процедура обновляет динамические списки Запасы
//
Процедура ОбновитьОтборПоГруппеДинамическихСписков()
	
	Если КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппам" Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Подразделение");
		ИмяДинамическогоСписка = "СписокИерархия";
		ИмяОтбора = "Родитель";
		
	ИначеЕсли КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоПодразделениям" Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Родитель");
		ИмяДинамическогоСписка = "СписокИерархияПоПодразделениям";
		ИмяОтбора = "Подразделение";
		
	КонецЕсли;
	
	ДанныеТекущейСтроки = Элементы[ИмяДинамическогоСписка].ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, ИмяОтбора);
	Иначе
		
		МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора);
		Если МассивЭлементов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора, ВидСравненияКомпоновкиДанных.ВИерархии, ДанныеТекущейСтроки.Ссылка);
		Иначе
			ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора, , ДанныеТекущейСтроки.Ссылка, ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры //ОбновитьОтборПоГруппеДинамическихСписков()

&НаСервере
Процедура ИзменитьТекстЗапросаСписок()
	
	ТекстЗапроса = Список.ТекстЗапроса;
	
	Если Объект.Подразделение.Пустая() Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Сотрудники.Подразделение = &Подразделение", "ИСТИНА");
	КонецЕсли;	
	
	Если Объект.ПоказыватьУволенных Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НЕ Сотрудники.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)", "ИСТИНА");
	КонецЕсли;	
	
	Список.ТекстЗапроса = ТекстЗапроса;	
КонецПроцедуры // ИзменитьТекстЗапросаСписок()

&НаСервере
// Процедура устанавливает значения параметров динамических списков 
//
// Значения считываются из реквизитов обработки
//
Процедура УстановитьПараметрыДинамическихСписков()
	
	//Параметры, заполняемые особым образом, например, Организация
	ПараметрОрганизация = Новый ПараметрКомпоновкиДанных("Организация");
	
	МассивСписков = Новый Массив;
	МассивСписков.Добавить(СписокИерархияПоПодразделениям);
	МассивСписков.Добавить(Список);
	
	Для каждого ДинамическийСписок Из МассивСписков Цикл
	
		Для Каждого ПараметрСписка Из ДинамическийСписок.Параметры.Элементы Цикл
			
			ЗначениеРеквизитаОбъекта = Неопределено;
			Если ПараметрСписка.Параметр = ПараметрОрганизация Тогда
				
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, Объект.Организация);
				
			ИначеЕсли ПараметрСписка.Параметр = ПараметрОрганизация Тогда
				
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, Объект.Организация);
				
			ИначеЕсли Объект.Свойство(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта) Тогда
				
				Если ТипЗнч(ЗначениеРеквизитаОбъекта) = Тип("СписокЗначений") Тогда
					
					ЗначениеРеквизитаОбъекта = СписокЗначенийВМассив(ЗначениеРеквизитаОбъекта);
					
				КонецЕсли;
				
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры // УстановитьПараметрыДинамическихСписков()

&НаКлиенте
// Процедура управляет переключением видов отборов
//
Процедура ПереключитьВидОтбора(ВидОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, КешНастройкиПодбора.ТекущийВидОтбора, "Пометка", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ВидОтбора, "Пометка", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархия", "Видимость", ВидОтбора = "ОтборПоГруппам");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияПоПодразделениям", "Видимость", ВидОтбора = "ОтборПоПодразделениям");
	
	КешНастройкиПодбора.ТекущийВидОтбора = ВидОтбора;
	
КонецПроцедуры // ПереключитьВидОтбора()

#КонецОбласти

// Преобразование типов

&НаСервере
// Преобразует набор данных с типом СписокЗначений в Массив
// 
Функция СписокЗначенийВМассив(ВхСписокЗначений) Экспорт
	
	МассивДанных = Новый Массив;
	
	Для каждого ЭлементСпискаЗначений Из ВхСписокЗначений Цикл
		
		МассивДанных.Добавить(ЭлементСпискаЗначений.Значение);
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции // СписокЗначенийВМассив()

// Конец Преобразование типов

&НаКлиенте
// Функция возвращает текущие данные строки элемента формы табличное поле
//
Функция ПолучитьДанныеТекущейСтрокиСписка()
	Возврат Элементы.Список.ТекущиеДанные;
КонецФункции // ПолучитьДанныеТекущейСтрокиСписка()

&НаСервере
// Процедура заполняет данные объекта по переданным параметрам
// вызывается событием ПриЗаписиОбъекта, 
//
Процедура ЗаполнитьДанныеОбъекта()
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
КонецПроцедуры // ЗаполнитьДанныеОбъекта()

&НаСервере
// Процедура заполняет сведения о документе вызвавшем подбор
// вызывается событием ПриЗаписиОбъекта, 
//
Процедура ЗаполнитьСведенияОДокументе(СведенияОДокументе)
	
	Обработки.ПодборСотрудника.СтруктураСведенийОДокументе(СведенияОДокументе);
	ЗаполнитьЗначенияСвойств(СведенияОДокументе, Объект);
	
КонецПроцедуры // ЗаполнитьСведенияОДокументе()

&НаСервере
// Функция помещает результаты подбора в хранилище
//
// Возвращает структуру:
//	Структура
//		- Адрес в хранилище, куда помещена выбранная позиция (корзина);
//		- Уникальный идентификатор формы владельца, необходим для идентификации при обработке результатов подбора;
//
Функция ЗаписатьПодборВХранилище() 
	
	АдресКорзиныВХранилище = ПоместитьВоВременноеХранилище(Объект.Корзина.Выгрузить(), Объект.УникальныйИдентификаторФормыВладельца);
	Возврат Новый Структура("АдресКорзиныВХранилище, УникальныйИдентификаторФормыВладельца", АдресКорзиныВХранилище, Объект.УникальныйИдентификаторФормыВладельца);
	
КонецФункции // ЗаписатьПодборВХранилище()

&НаСервере
// Процедура устанавливает свойства элементов формы
//
Процедура УстановитьСвойстваЭлементовФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаИзменитьВидимостьКорзины", "Пометка", Истина);
	
КонецПроцедуры // УстановитьСвойстваЭлементовФормы()

&НаКлиенте
// Процедура устанавливает переданный элемент формы текущим
//
Процедура УстановитьТекущийЭлементыФормы(Элемент)
	
	ЭтаФорма.ТекущийЭлемент = Элемент;
	
КонецПроцедуры // УстановитьТекущийЭлементыФормы()

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура обрабатывает результаты открытия дополнительной формы "Сведения о документе"
//
Процедура ПослеЗакрытияФормыСведенияОДокументе(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПараметрыОсновнойФормыПодбора = ДополнительныеПараметры;
	
КонецПроцедуры // ПослеЗакрытияФормыСведенияОДокументе()

#КонецОбласти
