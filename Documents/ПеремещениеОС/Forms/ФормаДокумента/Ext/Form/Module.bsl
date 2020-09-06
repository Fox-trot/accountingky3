﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	МОЛПередИзменением = Объект.МОЛОтправитель;
	ПодразделениеПередИзменением = Объект.ПодразделениеОтправитель;
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
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
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборОСПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьОСИзХранилища(АдресЗапасовВХранилище, "ОС");
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
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
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода МОЛОтправитель.
//
&НаКлиенте
Процедура МОЛОтправительПриИзменении(Элемент)
	Если МОЛПередИзменением <> Объект.МОЛОтправитель
		И НЕ Объект.ОС.Количество() = 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОчиститьТабличнуюЧасть", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть ""Основные средства"" будет очищена. Продолжить?'");
	
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		МОЛПередИзменением = Объект.МОЛОтправитель;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПодразделениеОтправитель.
//
&НаКлиенте
Процедура ПодразделениеОтправительПриИзменении(Элемент)
	Если ПодразделениеПередИзменением <> Объект.ПодразделениеОтправитель
		И НЕ Объект.ОС.Количество() = 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОчиститьТабличнуюЧасть", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть ""Основные средства"" будет очищена. Продолжить?'");
	
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		ПодразделениеПередИзменением = Объект.ПодразделениеОтправитель;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события Действие команды Подбор
//
&НаКлиенте
Процедура ПодборОС(Команда)
	УправлениеВнеоборотнымиАктивамиКлиент.ОткрытьПодбор(ЭтаФорма, "ОС");  
КонецПроцедуры

// Процедура - обработчик события Действие команды Заполнить
//
&НаКлиенте
Процедура ЗаполнитьДляСписка(Команда)
	Отказ = Ложь;
	
	Если Объект.ОС.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть ""ОС"". Операция отменена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ОС",,Отказ);		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.ОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьДляСписка", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные табличной части документа будут перезаполнены. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ДополнитьСтрокиНаСервере();
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события Действие команды Заполнить по наименованию
//
&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	// получаем текущую строку
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	Отказ = Ложь;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрана строка для заполнения. Операция отменена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ОС",,Отказ);		
	ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ОсновноеСредство) Тогда
		ТекстСообщения = НСтр("ru = 'В выбранной строке не заполнено основное средство. Операция отменена.'");
		ПолеСообщения = СтрШаблон("Объект.ОС[%1].ОсновноеСредство", СтрокаТабличнойЧасти.НомерСтроки-1);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	ДополнительныеПараметры = Новый Структура("ОсновноеСредство", СтрокаТабличнойЧасти.ОсновноеСредство);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьПоНаименованию", ЭтотОбъект, ДополнительныеПараметры);
	ТекстВопроса = НСтр("ru = 'Табличная часть документа будет дозаполнена. Продолжить выполнение операции?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросОчиститьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ОС.Очистить();
		МОЛПередИзменением = Объект.МОЛОтправитель;
		ПодразделениеПередИзменением = Объект.ПодразделениеОтправитель;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьДляСписка(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ДополнитьСтрокиНаСервере();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьПоНаименованию(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоНаименованиюНаСервере(ДополнительныеПараметры.ОсновноеСредство);
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, ДатаДокумента, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура получает список ОС из временного хранилища
//
&НаСервере
Процедура ПолучитьОСИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивОсновныхСредств = Новый Массив;
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", СтрокаЗагрузки.ОсновноеСредство));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		МассивОсновныхСредств.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	КонецЦикла;
	
	ДополнитьСтрокиНаСервере(МассивОсновныхСредств);
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Процедура заполняет строки
//
// Параметры:
//  МассивОсновныхСредств  - Массив - массив ОС, по которым нужно заполнить строки, если не указано- заполняются все строки
//
&НаСервере
Процедура ДополнитьСтрокиНаСервере(МассивОсновныхСредств = Неопределено)
	Если МассивОсновныхСредств = Неопределено Тогда 
		МассивОсновныхСредств = Объект.ОС.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	КонецЕсли;		
	
	Если МассивОсновныхСредств.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	УправлениеВнеоборотнымиАктивами.ЗаполнитьДанныеОсновныхСредствВТабличнойЧасти(Объект.Ссылка, ДатаДокумента, Объект.Организация, Объект.ОС, МассивОсновныхСредств);
КонецПроцедуры // ДополнитьСтрокиНаСервере()

// Процедура - Заполнить по наименованию на сервере
//
// Параметры:
//  СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - строка, по данным которой нужно выполнить заполнение
//
&НаСервере
Процедура ЗаполнитьПоНаименованиюНаСервере(ОсновноеСредство)
	НаименованиеОС = ОсновноеСредство.Наименование;
	
	МассивОсновныхСредств = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СостоянияОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство.Наименование = &НаименованиеОС
		|				И НЕ Регистратор = &Ссылка) КАК СостоянияОССрезПоследних
		|ГДЕ
		|	СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("НаименованиеОС", НаименованиеОС);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокиТабличнойЧасти = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", ВыборкаДетальныеЗаписи.ОсновноеСредство));
		
		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда 
			Продолжить;	
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Объект.ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);
		
		МассивОсновныхСредств.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	КонецЦикла;

	ДополнитьСтрокиНаСервере(МассивОсновныхСредств);
КонецПроцедуры // ЗаполнитьПоНаименованиюНаСервере()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
