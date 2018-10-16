﻿#Область ОбработчикиСобытийФормы

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
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов   
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборПроводокПроизведен"
		И ТипЗнч(Параметр) = Тип("Структура")
		//Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр.АдресЗапасовВХранилище;
		Если ЗначениеЗаполнено(АдресЗапасовВХранилище) Тогда
			
			ПолучитьЗапасыИзХранилища(АдресЗапасовВХранилище);
			
		КонецЕсли;
		
		ТекстОповещения = НСтр("ru = 'Заполнение'");
		ТекстПояснения = НСтр("ru = 'Табличная часть ""Проводки по документам"" заполнена.'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабличнаяЧастьПодобранныеПроводки

// Процедура - обработчик события ПриИзменении поля ввода ПодобранныеПроводкиСуммаКорректировки.
//
&НаКлиенте
Процедура ПодобранныеПроводкиСуммаКорректировкиПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ПодобранныеПроводки.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти.СуммаКорректировки > СтрокаТабличнойЧасти.СуммаПоСчету Тогда
		ТекстСообщения = НСтр("ru = 'Сумма корректировки не может быть больше суммы БУ'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,);
		СтрокаТабличнойЧасти.СуммаКорректировки = 0;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборПроводок(Команда)
	
	Если Объект.НачалоПериода > Объект.КонецПериода Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала периода не может быть больше даты окончания.'"));
		Возврат;	
	КонецЕсли;
	
	ПараметрыПодбора = Новый Структура;
	
	ПараметрыПодбора.Вставить("НачалоПериода", 			 Объект.НачалоПериода);
	ПараметрыПодбора.Вставить("КонецПериода", 			 Объект.КонецПериода);
	ПараметрыПодбора.Вставить("Организация", 			 Объект.Организация);
	ПараметрыПодбора.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	Если Объект.ПодобранныеПроводки.Количество() > 0 Тогда
		ДанныеТабличнойЧасти(ПараметрыПодбора);
	КонецЕсли;
	
	ОткрытьФорму("Документ.КорректировкаНУ.Форма.ФормаПодбораПроводок", ПараметрыПодбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДанныеТабличнойЧасти(ПараметрыПодбора)

	АдресВХранилище = ПоместитьВоВременноеХранилище(Объект.ПодобранныеПроводки.Выгрузить());
	ПараметрыПодбора.Вставить("АдресВХранилище", АдресВХранилище); 
	
КонецПроцедуры

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервере
Процедура ПолучитьЗапасыИзХранилища(АдресЗапасовВХранилище)
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл		
		НоваяСтрока = Объект.ПодобранныеПроводки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗагрузки);
		НоваяСтрока.СуммаКорректировки = СтрокаЗагрузки.СуммаПоСчету;
		НоваяСтрока.ВидУчета = Перечисления.ВидыУчета.ПР;
	КонецЦикла;
	
	Объект.ПодобранныеПроводки.Сортировать("ДокументПодбора");
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
