﻿
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
	
	ФормироватьНаименованиеПолноеАвтоматически = УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(
		Объект.Наименование,
		Объект.НаименованиеПолное,
		Объект.КодПравовойФормы);
	
	СтруктураДляПроверкиИНН = Новый Структура;
	
	СтруктураДляПроверкиИНН.Вставить("ИНН",							Объект.ИНН);
	СтруктураДляПроверкиИНН.Вставить("ЭтоЮрЛицо",					Истина);
	СтруктураДляПроверкиИНН.Вставить("ПроверитьИНН",				Истина);
	СтруктураДляПроверкиИНН.Вставить("ИННВведенКорректно",			Ложь);
	СтруктураДляПроверкиИНН.Вставить("ПустойИНН",					Ложь);

	ПроверитьКорректностьИНН(СтруктураДляПроверкиИНН, ЭтаФорма);

	Дата = ТекущаяДатаСеанса();
	
	ЗаполнитьДанныеОбОтветственныхЛицах();

	// Установить видимость и доступность элементов формы.
	УстановитьВидимостьДоступностьЭлементов();

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация");
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
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
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ФайлЛоготип) Тогда
		ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(ТекущийОбъект.ФайлЛоготип, УникальныйИдентификатор);
		Если ДвоичныеДанныеКартинки <> Неопределено Тогда
			АдресЛоготипа = ДвоичныеДанныеКартинки;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ФайлФаксимильнаяПечать) Тогда
		ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(ТекущийОбъект.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
		Если ДвоичныеДанныеКартинки <> Неопределено Тогда
			АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
		КонецЕсли;
	КонецЕсли;

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы"
		И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Если РаботаСЛоготипом Тогда
			
			Объект.ФайлЛоготип = ВыбранноеЗначение;
			ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФайлЛоготип, УникальныйИдентификатор);
			Если ДвоичныеДанныеКартинки <> Неопределено Тогда
				АдресЛоготипа = ДвоичныеДанныеКартинки;
			КонецЕсли;
			
		ИначеЕсли РаботаСФаксимиле Тогда
			
			Объект.ФайлФаксимильнаяПечать = ВыбранноеЗначение;
			ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
			Если ДвоичныеДанныеКартинки <> Неопределено Тогда
				АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УстановкаОсновногоСчета" И Параметр.Владелец = Объект.Ссылка Тогда
		
		Объект.ОсновнойБанковскийСчет = Параметр.НовыйОсновнойСчет;
		Если Не Модифицированность Тогда
			Записать();
		КонецЕсли;
		Оповестить("УстановкаОсновногоСчетаВыполнена");
		
	ИначеЕсли ИмяСобытия = "УстановкаОсновнойКассы" И Параметр.Владелец = Объект.Ссылка Тогда
		
		Объект.ОсновнаяКасса = Параметр.НоваяОсновнаяКасса;
		Если Не Модифицированность Тогда
			Записать();
		КонецЕсли;
		Оповестить("УстановкаОсновнойКассыВыполнена");
		
	ИначеЕсли ИмяСобытия = "ИзменениеОтветственныхЛиц"
		И Параметр.Организация = Объект.Ссылка
		И (Параметр.ОтветственноеЛицо = ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель")
		Или Параметр.ОтветственноеЛицо = ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер")) Тогда 
		
		ЗаполнитьДанныеОбОтветственныхЛицах();
		УстановитьВидимостьДоступностьЭлементов();
		
	ИначеЕсли ИмяСобытия = "УдалениеОтветственныхЛиц"
		И Параметр.Организация = Объект.Ссылка Тогда 
		
		ЗаполнитьДанныеОбОтветственныхЛицах();
		УстановитьВидимостьДоступностьЭлементов();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" Тогда
		
		Модифицированность	= Истина;
		Если РаботаСЛоготипом Тогда
			
			Объект.ФайлЛоготип = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
			ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФайлЛоготип, УникальныйИдентификатор);
			Если ДвоичныеДанныеКартинки <> Неопределено Тогда
				АдресЛоготипа = ДвоичныеДанныеКартинки;
			КонецЕсли;
			РаботаСЛоготипом = Ложь;
			
		ИначеЕсли РаботаСФаксимиле Тогда
			
			Объект.ФайлФаксимильнаяПечать = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
			ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
			Если ДвоичныеДанныеКартинки <> Неопределено Тогда 
				АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
			КонецЕсли;
			РаботаСФаксимиле = Ложь;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	ОбновитьИнтерфейс = ТекущийОбъект.ЭтоНовый() И НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	Оповестить("Запись_Организации", Объект.Ссылка, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Наименование.
//
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	СформироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КодПравовойФормы.
//
&НаКлиенте
Процедура КодПравовойФормыПриИзменении(Элемент)
	СформироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода НаименованиеПолное.
//
&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	ФормироватьНаименованиеПолноеАвтоматически = УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(
		Объект.Наименование,
		Объект.НаименованиеПолное,
		Объект.КодПравовойФормы);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Префикс.
//
&НаКлиенте
Процедура ПрефиксПриИзменении(Элемент)
	Если Найти(Объект.Префикс, "-") > 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нельзя в префиксе организации использовать символ ""-"".'"));
		Объект.Префикс = СтрЗаменить(Объект.Префикс, "-", "");
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита ИНН
//
&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	СтруктураДляПроверкиИНН.Вставить("ИНН", Объект.ИНН);
	ПроверитьКорректностьИНН(СтруктураДляПроверкиИНН, ЭтаФорма);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнойБанковскийСчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяКассаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресЛоготипаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	УправлениеФлагамиРаботыСКартинками(Истина, Ложь);
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФаксимильнойПечатиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	УправлениеФлагамиРаботыСКартинками(Ложь, Истина);
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПредварительныйПросмотрПечатнойФормыСчетНаОплату(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.Организации",
		"ПредварительныйПросмотрПечатнойФормыСчетНаОплату",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка),
		ЭтотОбъект,
		Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеЛоготипа(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьИзображениеЛоготипаЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеЛоготипаФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображениеЛоготипа(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Объект.ФайлЛоготип) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФормуФайла(Объект.ФайлЛоготип);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутстует изображение для редактирования'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресЛоготипа");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображениеЛоготипа(Команда)
	
	Объект.ФайлЛоготип = Неопределено;
	АдресЛоготипа = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ЛоготипИзПрисоединенныхФайлов(Команда)
	
	УправлениеФлагамиРаботыСКартинками(Истина, Ложь);
	ВыбратьКартинкуИзПрисоединенныхФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимиле(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьИзображениеФаксимилеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеФаксимилеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображениеФаксимиле(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Объект.ФайлФаксимильнаяПечать) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФормуФайла(Объект.ФайлФаксимильнаяПечать);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутстует изображение для редактирования'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресФаксимильнойПечати");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображениеФаксимиле(Команда)
	
	Объект.ФайлФаксимильнаяПечать = Неопределено;
	АдресФаксимильнойПечати = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ФаксимилеИзПрисоединенныхФайлов(Команда)
	
	УправлениеФлагамиРаботыСКартинками(Ложь, Истина);
	ВыбратьКартинкуИзПрисоединенныхФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбор = Новый Структура(
	"Период, Организация, ОтветственноеЛицо, Касса",
		РуководительПериод,
		Объект.Ссылка,
		ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель"),
		ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка"));
	
	ТипЗначения = Тип("РегистрСведенийКлючЗаписи.ОтветственныеЛицаОрганизаций");
	
	ПараметрыЗаписи = Новый Массив(1);
	ПараметрыЗаписи[0] = СтруктураОтбор;
	
	КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);

	Параметрыформы = Новый Структура;
	Параметрыформы.Вставить("Ключ", КлючЗаписи);
		
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", Параметрыформы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РуководительНеЗаданНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.
			|Нажмите на кнопку ""Записать"" и повторите действие по назначению руководителя.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Период", Дата);
	ЗначенияЗаполнения.Вставить("Организация", Объект.Ссылка);
	ЗначенияЗаполнения.Вставить("ОтветственноеЛицо", ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель"));
	Параметрыформы = Новый Структура;
	Параметрыформы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", Параметрыформы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбор = Новый Структура(
	"Период, Организация, ОтветственноеЛицо, Касса",
		ГлавныйБухгалтерПериод,
		Объект.Ссылка,
		ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер"),
		ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка"));
	
	ТипЗначения = Тип("РегистрСведенийКлючЗаписи.ОтветственныеЛицаОрганизаций");
	
	ПараметрыЗаписи = Новый Массив(1);
	ПараметрыЗаписи[0] = СтруктураОтбор;
	
	КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);

	Параметрыформы = Новый Структура;
	Параметрыформы.Вставить("Ключ", КлючЗаписи);
		
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", Параметрыформы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерНеЗаданНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.
			|Нажмите на кнопку ""Записать"" и повторите действие по назначению главного бухгалтера.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Период", Дата);
	ЗначенияЗаполнения.Вставить("Организация", Объект.Ссылка);
	ЗначенияЗаполнения.Вставить("ОтветственноеЛицо", ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер"));
	Параметрыформы = Новый Структура;
	Параметрыформы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", Параметрыформы, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ФаксимилеИЛоготип

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор)
	
	Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура УправлениеФлагамиРаботыСКартинками(ЭтоРаботаСЛоготипом = Ложь, ЭтоРаботаСФаксимиле = Ложь)
	
	РаботаСЛоготипом = ЭтоРаботаСЛоготипом;
	РаботаСФаксимиле = ЭтоРаботаСФаксимиле;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	
	ОчиститьСообщения();
	
	ИмяРеквизитаОбъекта = "";
	
	Если РаботаСЛоготипом Тогда
		
		ИмяРеквизитаОбъекта = "ФайлЛоготип";
		
	ИначеЕсли РаботаСФаксимиле Тогда
		
		ИмяРеквизитаОбъекта = "ФайлФаксимильнаяПечать";
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИмяРеквизитаОбъекта)
		И ЗначениеЗаполнено(Объект[ИмяРеквизитаОбъекта]) Тогда
		
		ДанныеФайла = ПолучитьДанныеФайла(Объект[ИмяРеквизитаОбъекта], УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутстует изображение для просмотра'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьИзображениеНаКлиентеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Записать();
	
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеФрагмент()
	
	Перем ИдентификаторФайла, ИмяРеквизитаОбъекта, Фильтр;
	
	Если РаботаСЛоготипом Тогда
		
		ИмяРеквизитаОбъекта = "ФайлЛоготип";
		
	ИначеЕсли РаботаСФаксимиле Тогда
		
		ИмяРеквизитаОбъекта = "ФайлФаксимильнаяПечать";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект[ИмяРеквизитаОбъекта]) Тогда
		
		ПросмотретьПрисоединенныйФайл();
		
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		
		Фильтр = НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf"
		+ "|Все файлы(*.*)|*.*"
		+ "|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle"
		+ "|Формат GIF(*.gif*)|*.gif"
		+ "|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg"
		+ "|Формат PNG(*.png*)|*.png"
		+ "|Формат TIFF(*.tif)|*.tif"
		+ "|Формат icon(*.ico)|*.ico"
		+ "|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
		
		РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла, Фильтр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", Объект.Ссылка);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеЛоготипаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат
	КонецЕсли;
	
	Записать();
	
	
	ДобавитьИзображениеЛоготипаФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеЛоготипаФрагмент()
	
	Перем ИдентификаторФайла;
	
	УправлениеФлагамиРаботыСКартинками(Истина, Ложь);
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимилеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат
	КонецЕсли;
	
	Записать();
	
	ДобавитьИзображениеФаксимилеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимилеФрагмент()
	
	Перем ИдентификаторФайла;
	
	УправлениеФлагамиРаботыСКартинками(Ложь, Истина);
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуКартинки(ФайлКартинки, ИдентификаторФормы)
	
	Попытка     
		Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.НадписьПоясненияНекорректногоИНН.Видимость = НЕ СтруктураДляПроверкиИНН.ИННВведенКорректно;
	
	Если ЗначениеЗаполнено(Руководитель) Тогда 
		Элементы.Руководитель.Видимость = Истина;
		Элементы.РуководительНеЗадан.Видимость = Ложь;
	Иначе 
		Элементы.Руководитель.Видимость = Ложь;
		Элементы.РуководительНеЗадан.Видимость = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГлавныйБухгалтер) Тогда 
		Элементы.ГлавныйБухгалтер.Видимость = Истина;
		Элементы.ГлавныйБухгалтерНеЗадан.Видимость = Ложь;
	Иначе 
		Элементы.ГлавныйБухгалтер.Видимость = Ложь;
		Элементы.ГлавныйБухгалтерНеЗадан.Видимость = Истина;
	КонецЕсли;		

КонецПроцедуры 

// Процедура управляет информационными надписями о корректности заполнения ИНН.
// 
&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьКорректностьИНН(СтруктураПараметров, Форма)
	ВозвращеннаяСтруктура = БухгалтерскийУчетКлиентСервер.ПроверитьКорректностьИНН(СтруктураПараметров);
	
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ВозвращеннаяСтруктура);
	ЗаполнитьЗначенияСвойств(Форма, ВозвращеннаяСтруктура);
КонецПроцедуры

// Присваивает соответствующее значение переменной ФормироватьНаименованиеПолноеАвтоматически.
//
//
&НаКлиентеНаСервереБезКонтекста
Функция УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(Наименование, НаименованиеПолное, КодПравовойФормы)
	Возврат (СтрШаблон("%1 ""%2""", КодПравовойФормы, Наименование) = НаименованиеПолное ИЛИ ПустаяСтрока(НаименованиеПолное));
КонецФункции // УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

// Процедура формирует полное наименование.
//
&НаКлиенте
Процедура СформироватьНаименованиеПолноеАвтоматически()

	Если НЕ ФормироватьНаименованиеПолноеАвтоматически Тогда 
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.КодПравовойФормы) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	Иначе
		Объект.НаименованиеПолное = СтрШаблон("%1 ""%2""", Объект.КодПравовойФормы, Объект.Наименование);
	КонецЕсли;

КонецПроцедуры // СформироватьНаименованиеПолноеАвтоматически()

&НаСервере
Процедура ЗаполнитьДанныеОбОтветственныхЛицах()
	ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Объект.Ссылка, Дата);	
	
	РуководительПериод = ОтветственныеЛица.РуководительПериод;
	Руководитель = ОтветственныеЛица.РуководительФизЛицо;
	РуководительНеЗадан = НСтр("ru = 'Назначить руководителя'");
	
	ГлавныйБухгалтерПериод = ОтветственныеЛица.ГлавныйБухгалтерПериод;
	ГлавныйБухгалтер = ОтветственныеЛица.ГлавныйБухгалтерФизЛицо;
	ГлавныйБухгалтерНеЗадан = НСтр("ru = 'Назначить главного бухгалтера'");
	
КонецПроцедуры // ЗаполнитьДанныеОКассире()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрыОткрытия = Новый Структура("Страна", ПредопределенноеЗначение("Справочник.СтраныМира.Киргизия"));
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка, ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	ПараметрыОткрытия = Новый Структура("Страна", ПредопределенноеЗначение("Справочник.СтраныМира.Киргизия"));
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка, ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

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