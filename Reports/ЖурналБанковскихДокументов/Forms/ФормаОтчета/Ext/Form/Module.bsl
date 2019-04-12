﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	Если НЕ ЗначениеЗаполнено(Отчет.НачалоПериода) Тогда
		Отчет.НачалоПериода = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.КонецПериода) Тогда
		Отчет.КонецПериода  = КонецДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
		Отчет.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.БанковскийСчет) Тогда
		Отчет.БанковскийСчет = Отчет.Организация.ОсновнойБанковскийСчет;	
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	БухгалтерскиеОтчетыВызовСервера.СоздатьРеквизитыПоказателей(ЭтаФорма);
	Элементы.РассчитатьСумму.Пометка = Истина;
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = НЕ Отчет.РежимРасшифровки;	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);

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
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отчет.РежимРасшифровки Тогда
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода НачалоПериода.
//
&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КонецПериода.
//
&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ЗаполнитьБанковскийСчетНаСервере();
	Иначе
		Отчет.БанковскийСчет = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СписокВыбораЛиста.
//
&НаКлиенте
Процедура СписокВыбораЛистаПриИзменении(Элемент)
	
	ПоказатьВыбранныйЛист();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезультат

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

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
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтправитьОтчет(ЭтотОбъект);

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
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаВесьЭкран(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата());

	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтаФорма);
	ТекущийЭлемент = Элементы.Сформировать;
	
КонецПроцедуры

#Область ОбработчикиКомандРасчетаПоказателей

&НаКлиенте
Процедура РассчитатьСумму(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьКоличество(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСреднее(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМинимум(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМаксимум(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьВсеПоказатели(Команда)
	УстановитьВидимостьПоказателей(Не Элементы.РассчитатьВсеПоказатели.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура СвернутьПоказатели(Команда)
	УстановитьВидимостьПоказателей(Ложь);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = СтрШаблон(НСтр("ru = 'Журнал банковских документов %1'"), 
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
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если НЕ ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.ЖурналБанковскихДокументов.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.ЖурналБанковскихДокументов.СформироватьОтчет",
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
	ПараметрыОтчета.Вставить("Организация"					, Отчет.Организация);
	ПараметрыОтчета.Вставить("БанковскийСчет"             	, Отчет.БанковскийСчет);
	ПараметрыОтчета.Вставить("НачалоПериода"               	, Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                	, Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("РежимРасшифровки"            	, Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("СписокСформированныхЛистов"  	, Отчет.СписокСформированныхЛистов);
	ПараметрыОтчета.Вставить("СортироватьПоВиду"			, Отчет.СортироватьПоВиду);
	ПараметрыОтчета.Вставить("СортироватьПоНомеру"			, Отчет.СортироватьПоНомеру);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"         	, БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	ВозвращаемыеПараметры = ПолучитьИзВременногоХранилища(АдресХранилища);
	Отчет.СписокСформированныхЛистов = ВозвращаемыеПараметры;
	
	Элементы.СписокВыбораЛиста.СписокВыбора.Очистить();
	Если Отчет.СписокСформированныхЛистов.Количество() > 0 Тогда
		Для каждого Лист Из Отчет.СписокСформированныхЛистов Цикл
			Элементы.СписокВыбораЛиста.СписокВыбора.Добавить(Лист.Представление);
		КонецЦикла;
		
		СписокВыбораЛиста = Отчет.СписокСформированныхЛистов.Получить(0).Представление;
		Элементы.СписокВыбораЛиста.Видимость = Истина;
		
	КонецЕсли;
	
	ПоказатьВыбранныйЛист();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	Перем ТекущаяКоманда;
	
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Если Элементы[Команда.Ключ].Пометка Тогда 
			ТекущаяКоманда = Команда.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	РассчитатьПоказатели(ТекущаяКоманда);
	
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

&НаСервере
Процедура ЗаполнитьБанковскийСчетНаСервере()

	Отчет.БанковскийСчет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отчет.Организация, "ОсновнойБанковскийСчет");
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьВыбранныйЛист()
	
	Результат.Очистить();
	Результат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КассоваяКнига";
	Результат.ПолеСлева = 20;
	
	ИндексСформированногоЛиста = ПолучитьИндексСформированногоЛиста(СписокВыбораЛиста, Отчет.СписокСформированныхЛистов);
	
	Если ИндексСформированногоЛиста <> Неопределено Тогда
		СформированныйЛист = Отчет.СписокСформированныхЛистов.Получить(ИндексСформированногоЛиста).Значение;
		Результат.Вывести(СформированныйЛист);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИндексСформированногоЛиста(ИмяЛиста, СписокСформированныхЛистов)
	
	Если ИмяЛиста = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для каждого Лист Из СписокСформированныхЛистов Цикл
		Если Лист.Представление = ИмяЛиста Тогда
			Возврат СписокСформированныхЛистов.Индекс(Лист);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция АдресХранилищаРезультата()
	
	Возврат ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
КонецФункции

#Область РасчетПоказателейВыделенныхЯчеек

// Выполняет расчет и вывод показателей выделенной области ячеек.
// См. обработчик события ОтчетТабличныйДокументПриАктивизацииОбласти.
//
&НаКлиенте
Процедура РассчитатьПоказателиДинамически()
	Перем ТекущаяКоманда;
	
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Если Элементы[Команда.Ключ].Пометка Тогда 
			ТекущаяКоманда = Команда.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	РассчитатьПоказатели(ТекущаяКоманда);
КонецПроцедуры

// Выполняет расчет и вывод показателей выделенных областей ячеек табличного документа.
//
// Параметры:
//  ТекущаяКоманда - Строка - имя команды расчета показателя, например, "РассчитатьСумму".
//                      Определяет, какой показатель является основным.
//
&НаКлиенте
Процедура РассчитатьПоказатели(ТекущаяКоманда = "РассчитатьСумму")
	// Расчет показателей.
	ПараметрыРасчета = ОбщегоНазначенияСлужебныйКлиент.ПараметрыРасчетаПоказателейЯчеек(Результат);
	Если ПараметрыРасчета.РассчитатьНаСервере Тогда 
		РасчетныеПоказатели = РасчетныеПоказателиСервер(ПараметрыРасчета);
	Иначе
		РасчетныеПоказатели = ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(
			Результат, ПараметрыРасчета.ВыделенныеОбласти);
	КонецЕсли;
	
	// Установка значений показателей.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РасчетныеПоказатели);
	
	// Переключение и форматирование показателей.
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Элементы[Команда.Ключ].Пометка = Ложь;
		
		ЗначениеПоказателя = РасчетныеПоказатели[Команда.Значение];
		РазрядностьПоказателя = Мин(СтрДлина(Макс(ЗначениеПоказателя, -ЗначениеПоказателя) % 1) - 2, 4);
		
		Элементы[Команда.Значение].ФорматРедактирования = "ЧДЦ=" + РазрядностьПоказателя + "; ЧРГ=' '; ЧН=0";
	КонецЦикла;
	Элементы[ТекущаяКоманда].Пометка = Истина;
	
	// Вывод основного показателя.
	ТекущийПоказатель = КомандыПоказателей[ТекущаяКоманда];
	БыстрыйПоказатель = ЭтотОбъект[ТекущийПоказатель];
	Элементы.БыстрыйПоказатель.ФорматРедактирования = Элементы[ТекущийПоказатель].ФорматРедактирования;
	Элементы.ГруппаВидыПоказателей.Картинка = БиблиотекаКартинок[ТекущийПоказатель];
КонецПроцедуры

// Рассчитывает показатели числовых ячеек в табличном документе.
//  см. ОтчетыКлиентСервер.РасчетныеПоказателиЯчеек.
//
&НаСервере
Функция РасчетныеПоказателиСервер(ПараметрыРасчета)
	Возврат ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(Результат, ПараметрыРасчета.ВыделенныеОбласти);
КонецФункции

// Определяет соответствие между командами расчета показателей и показателями.
//
// Возвращаемое значение:
//   Соответствие - Ключ - имя команды, Значение - имя показателя.
//
&НаКлиенте
Функция КомандыПоказателей()
	КомандыПоказателей = Новый Соответствие();
	КомандыПоказателей.Вставить("РассчитатьСумму", "Сумма");
	КомандыПоказателей.Вставить("РассчитатьКоличество", "Количество");
	КомандыПоказателей.Вставить("РассчитатьСреднее", "Среднее");
	КомандыПоказателей.Вставить("РассчитатьМинимум", "Минимум");
	КомандыПоказателей.Вставить("РассчитатьМаксимум", "Максимум");
	
	Возврат КомандыПоказателей;
КонецФункции

// Управляет признаком видимости панели расчетных показателей.
//
// Параметры:
//  Видимость - Булево - Признак включения / выключения видимости панели показателей.
//              См. также Синтакс-помощник: ГруппаФормы.Видимость.
//
&НаКлиенте
Процедура УстановитьВидимостьПоказателей(Видимость)
	Элементы.ОбластьПоказателей.Видимость = Видимость;
	Элементы.РассчитатьВсеПоказатели.Пометка = Видимость;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
