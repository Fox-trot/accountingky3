﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		Запись.Период = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ОтветственноеЛицо) Тогда
		Элементы.ОтветственноеЛицо.Вид        = ВидПоляФормы.ПолеНадписи;
		Элементы.ОтветственноеЛицо.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.Организация) Тогда 
		Запись.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;	
	
	Элементы.Организация.Видимость = НЕ ЗначениеЗаполнено(Запись.Организация);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если ЗначениеЗаполнено(ТекущийОбъект.ФайлФаксимильнаяПечать) Тогда
		ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(ТекущийОбъект.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
		Если ДвоичныеДанныеКартинки <> Неопределено Тогда
			АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы"
		И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Запись.ФайлФаксимильнаяПечать = ВыбранноеЗначение;
		ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(Запись.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
		Если ДвоичныеДанныеКартинки <> Неопределено Тогда
			АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Модифицированность	= Истина;
		Запись.ФайлФаксимильнаяПечать = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
		ДвоичныеДанныеКартинки = ПолучитьНавигационнуюСсылкуКартинки(Запись.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
		Если ДвоичныеДанныеКартинки <> Неопределено Тогда 
			АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		ОтветственныеЛицаОрганизаций	= РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(ОтветственныеЛицаОрганизаций, Запись.ИсходныйКлючЗаписи);
		ОтветственныеЛицаОрганизаций.Прочитать();
		
		СтруктураСтаройЗаписи	= Новый Структура("Период, Организация, ОтветственноеЛицо, ФизЛицо, Должность, Касса");
		ЗаполнитьЗначенияСвойств(СтруктураСтаройЗаписи, ОтветственныеЛицаОрганизаций);
		ПараметрыЗаписи.Вставить("СтруктураСтаройЗаписи", СтруктураСтаройЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("СтруктураСтаройЗаписи") Тогда
		
		// Если была изменена дата и хотя бы одно из полей, тогда сохраним прежнюю запись	
		Если НЕ ТекущийОбъект.Период = ПараметрыЗаписи.СтруктураСтаройЗаписи.Период
				И (НЕ ТекущийОбъект.ФизЛицо = ПараметрыЗаписи.СтруктураСтаройЗаписи.ФизЛицо
					ИЛИ НЕ ТекущийОбъект.Должность = ПараметрыЗаписи.СтруктураСтаройЗаписи.Должность) Тогда
					
			ОтветственныеЛицаОрганизаций	= РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(ОтветственныеЛицаОрганизаций, ТекущийОбъект);
			ЗаполнитьЗначенияСвойств(ОтветственныеЛицаОрганизаций, ПараметрыЗаписи.СтруктураСтаройЗаписи);
			ОтветственныеЛицаОрганизаций.Записать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Организация", Запись.Организация);
	СтруктураДанные.Вставить("ОтветственноеЛицо", Запись.ОтветственноеЛицо);
	СтруктураДанные.Вставить("Касса", Запись.Касса);
	
	Оповестить("ИзменениеОтветственныхЛиц", СтруктураДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	Запись.Должность = ПолучитьДолжностьФизЛица(Запись.Организация, Запись.ФизЛицо);
	Запись.ФайлФаксимильнаяПечать = Неопределено;
	АдресФаксимильнойПечати = "";
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ОтветственноеЛицо.
//
&НаКлиенте
Процедура ОтветственноеЛицоПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсторияИзменений(Команда)
	Отбор	= Новый Структура("Организация, ОтветственноеЛицо");
	ЗаполнитьЗначенияСвойств(Отбор, Запись);
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаСписка", Новый Структура("Отбор", Отбор));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.Касса.Видимость = Запись.ОтветственноеЛицо = Справочники.ВидыОтветственныхЛиц.Кассир;
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьДолжностьФизЛица(Организация, ФизЛицо)
	
	СведенияОСотруднике = ПроведениеРасчетовПоЗарплатеСервер.СведенияОСотруднике(ТекущаяДатаСеанса(), Организация, ФизЛицо); 

	Если ЗначениеЗаполнено(СведенияОСотруднике.Должность) Тогда
		Возврат СведенияОСотруднике.Должность;
	КонецЕсли;
	
	Возврат Справочники.Должности.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область Факсимиле

&НаКлиенте
Процедура АдресФаксимильнойПечатиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимиле(Команда)
	
	Если НЕ ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для выбора изображения необходимо указать сотрудника'"), 10);
		Возврат;
	КонецЕсли;
	
	ДобавитьИзображениеФаксимилеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображениеФаксимиле(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Запись.ФайлФаксимильнаяПечать) Тогда
		РаботаСФайламиКлиент.ОткрытьФормуФайла(Запись.ФайлФаксимильнаяПечать);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутстует изображение для редактирования'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресФаксимильнойПечати");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображениеФаксимиле(Команда)
	
	Запись.ФайлФаксимильнаяПечать = Неопределено;
	АдресФаксимильнойПечати = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ФаксимилеИзПрисоединенныхФайлов(Команда)
	
	ВыбратьКартинкуИзПрисоединенныхФайлов();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор)
	
	Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, Новый Структура("ИдентификаторФормы", УникальныйИдентификатор));
	
КонецФункции

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Запись.ФайлФаксимильнаяПечать) Тогда
		
		ДанныеФайла = ПолучитьДанныеФайла(Запись.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутстует изображение для просмотра'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для выбора изображения необходимо указать сотрудника'"), 10);
		Возврат;
	КонецЕсли;
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеФрагмент()
	
	Перем ИдентификаторФайла, ИмяРеквизитаОбъекта, Фильтр;
	
	Если ЗначениеЗаполнено(Запись.ФайлФаксимильнаяПечать) Тогда
		
		ПросмотретьПрисоединенныйФайл();
		
	ИначеЕсли ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
		
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
		
		РаботаСФайламиКлиент.ДобавитьФайлы(Запись.ФизЛицо, ИдентификаторФайла, Фильтр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", Запись.ФизЛицо);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимилеФрагмент()
	
	Перем ИдентификаторФайла;
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(Запись.ФизЛицо, ИдентификаторФайла);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуКартинки(ФайлКартинки, ИдентификаторФормы)
	
	Попытка
		Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, Новый Структура("ИдентификаторФормы", ИдентификаторФормы)).СсылкаНаДвоичныеДанныеФайла;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

#КонецОбласти
